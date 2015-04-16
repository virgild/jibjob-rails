#!/bin/bash
set -e

export PATH=${RUBY_PATH}:${PATH}
export RAILS_ENV=${RAILS_ENV:-development}

HAS_APP=0
PROGRAM=$1
PROGRAM_ARGS=${*:2:500}

function coloredEcho() {
  local exp=$1;
  local color=$2;
  if ! [[ $color =~ '^[0-9]$' ]] ; then
     case $(echo $color | tr '[:upper:]' '[:lower:]') in
       black) color=0 ;;
       red) color=1 ;;
       green) color=2 ;;
       yellow) color=3 ;;
       blue) color=4 ;;
       magenta) color=5 ;;
       cyan) color=6 ;;
       white|*) color=7 ;; # white or invalid color
     esac
  fi
  tput setaf $color;
  echo $exp;
  tput sgr0;
}

# Check app directory
coloredEcho "Checking /app directory..." cyan
if [[ -d /app ]]; then
  if [[ -e /app/bin/rails ]]; then
    HAS_APP=1
    coloredEcho "Found Rails app in /app." green
  else
    coloredEcho "Cannot find Rails app in /app." red
    exit 1
  fi
else
  coloredEcho "Cannot find /app. Mount the Rails root to /app in this container." red
  exit 1
fi

# Prepare app

# Initialize fonts
function prepare_fonts()
{
  coloredEcho "Copying fonts from /app/app/assets/fonts/print and refreshing font cache..." cyan
  cp -R /app/app/assets/fonts/print/* /opt/fonts/truetype/
  fc-cache -f
}

# Prepare gems directory
coloredEcho "Checking /vendor/bundle directory..." cyan
if [[ ! -d /vendor/bundle ]]; then
  coloredEcho "/vendor/bundle not found. Creating..." yellow
  mkdir -p /vendor/bundle
fi
chown -R jibjob:jibjob /vendor

# Run bundler
if [[ $SKIP_BUNDLER == "1" ]]; then
  coloredEcho "(Skipping bundler...)" yellow
else
  coloredEcho "Running bundler..." cyan
  gosu jibjob touch /vendor/BUNDLER_RUNNING
  cd /app
  gosu jibjob bundle install --path=/vendor/bundle &> /vendor/bundle/install.log
  gosu jibjob rm -f /vendor/BUNDLER_RUNNING
  coloredEcho "Finished bundler install." green
fi

# Prepare attachments (Rails public/system) directory
coloredEcho "Checking /app/public/system mount..." cyan
if [[ ! -d /app/public/system ]]; then
  coloredEcho "WARNING: /app/public/system is not mounted." red
else
  if [[ `stat -f -L -c %T /app/public/system` == "nfs" ]]; then
    coloredEcho "WARNING: /app/public/system is an NFS directory. It may not be writable." red
  else
    chown -R jibjob:jibjob /app/public/system
    coloredEcho "/app/public/system is mounted." green
  fi
fi

# Configure nginx
coloredEcho "Configuring nginx with RAILS_ENV=${RAILS_ENV}..." cyan
erb /config/nginx.conf.erb > /opt/nginx/conf/nginx.conf
coloredEcho "Written config to /opt/ntinx/conf/nginx.conf" green

# Invoke mode program
echo
case $PROGRAM in
  console)
    coloredEcho "Starting jibjob shell..." green
    exec gosu jibjob /bin/bash --login
    ;;
  server)
    prepare_fonts
    echo
    coloredEcho "Starting nginx..." green
    exec /opt/nginx/sbin/nginx
    ;;
  worker)
    prepare_fonts
    echo
    coloredEcho "Running sidekiq..." green
    cd /app
    exec gosu jibjob bin/sidekiq ${PROGRAM_ARGS}
    ;;
  root)
    coloredEcho "Starting root shell..." green
    exec bash -l
    ;;
  *)
    coloredEcho "Unknown mode...doing nothing." yellow
    exit 1
    ;;
esac

#!/bin/bash
set -e

export PATH=${RUBY_PATH}:${PATH}
export RAILS_ENV=${RAILS_ENV:-development}

HAS_APP=0
PROGRAM=$1
PROGRAM_ARGS=${*:2:500}

has_missing_config_files=0

# Check app directory
printf "Checking /app directory..."
if [[ -d /app ]]; then
  if [[ -e /app/bin/rails ]]; then
    HAS_APP=1
    printf "Found Rails app in /app.\n"
  else
    printf "Cannot find Rails app in /app.\n"
    exit 1
  fi
else
  printf "Cannot find /app. Mount the Rails root to /app in this container.\n"
  exit 1
fi

# Prepare app
if [[ $RAILS_ENV != "development" ]]; then
  chown -R jibjob:jibjob /app
fi

# Initialize fonts
function prepare_fonts()
{
  printf "Copying fonts from /app/app/assets/fonts/print and refreshing font cache..."
  cp -R /app/app/assets/fonts/print/* /opt/fonts/truetype/
  fc-cache -f
  printf "done.\n"
}

function check_config_files()
{
  echo "Checking /app/config/ files..."
  printf " - database.yml..."
  if [[ -e /app/config/database.yml ]]; then
    printf "OK\n"
  else
    has_missing_config_files=1
    printf "NOT FOUND\n"
  fi

  printf " - mailer.yml..."
  if [[ -e /app/config/mailer.yml ]]; then
    printf "OK\n"
  else
    has_missing_config_files=1
    printf "NOT FOUND\n"
  fi
}

# Check files and directories
check_config_files

# Prepare gems directory
printf "Checking /vendor/bundle directory..."
if [[ ! -d /vendor/bundle ]]; then
  printf "ERROR: /vendor/bundle not found."
  exit 1
fi
chown -R jibjob:jibjob /vendor
printf "done.\n"

# Run bundler
printf "Running bundler..."
gosu jibjob touch /vendor/BUNDLER_RUNNING
cd /app
gosu jibjob bundle install --path=/vendor/bundle --no-cache --shebang=${RUBY_PATH}/ruby &> /vendor/bundle/install.log
gosu jibjob rm -f /vendor/BUNDLER_RUNNING
printf "finished bundler install.\n"

# Prepare attachments (Rails public/system) directory
echo "Checking /app/public/system mount..."
if [[ ! -d /app/public/system ]]; then
  echo " - ERROR: /app/public/system is not mounted."
  exit 1
else
  if [[ `stat -f -L -c %T /app/public/system` == "nfs" ]]; then
    echo " - WARNING: /app/public/system is an NFS directory. It may not be writable."
  else
    chown -R jibjob:jibjob /app/public/system
    echo " - /app/public/system is mounted."
  fi
fi

# Configure nginx
echo "Configuring nginx with RAILS_ENV=${RAILS_ENV}..."
erb /config/nginx.conf.erb > /opt/nginx/conf/nginx.conf
echo " - Written config to /opt/ntinx/conf/nginx.conf"

if [[ $has_missing_config_files -eq 1 ]]; then
  echo
  echo "-----------------------------------------"
  echo "WARNING - There are missing config files."
  echo "-----------------------------------------"
fi

# Invoke mode program
case $PROGRAM in
  console)
    echo
    echo "Starting jibjob shell..."
    exec gosu jibjob /bin/bash --login
    ;;
  server)
    prepare_fonts
    echo
    echo "Starting nginx..."
    exec /opt/nginx/sbin/nginx
    ;;
  worker)
    prepare_fonts
    echo
    echo "Running sidekiq..."
    cd /app
    exec gosu jibjob bin/sidekiq ${PROGRAM_ARGS}
    ;;
  root)
    echo
    echo "Starting root shell..."
    exec bash -l
    ;;
  *)
    echo
    echo "Unknown mode...doing nothing."
    exit 1
    ;;
esac

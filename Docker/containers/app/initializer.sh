#!/bin/bash
set -e

export PATH=${RUBY_PATH}:${PATH}
export RAILS_ENV=${RAILS_ENV:-development}

HAS_APP=0
PROGRAM=$1
PROGRAM_ARGS=${*:2:500}

# Check app directory
echo "Checking /app directory..."
if [[ -d /app ]]; then
  if [[ -e /app/bin/rails ]]; then
    HAS_APP=1
    echo "Found Rails app in /app."
  else
    echo "Cannot find Rails app in /app."
    exit 1
  fi
else
  echo "Cannot find /app. Mount the Rails root to /app in this container."
  exit 1
fi

# Prepare app

# Initialize fonts
function prepare_fonts()
{
  echo "Copying fonts from /app/app/assets/fonts/print and refreshing font cache..."
  cp -R /app/app/assets/fonts/print/* /opt/fonts/truetype/
  fc-cache -f
}

# Prepare gems directory
echo "Checking /vendor/bundle directory..."
if [[ ! -d /vendor/bundle ]]; then
  echo "/vendor/bundle not found. Creating..."
  mkdir -p /vendor/bundle
fi
chown -R jibjob:jibjob /vendor

# Run bundler
if [[ $SKIP_BUNDLER == "1" ]]; then
  echo "(Skipping bundler...)"
else
  echo "Running bundler..."
  gosu jibjob touch /vendor/BUNDLER_RUNNING
  cd /app
  gosu jibjob bundle install --path=/vendor/bundle &> /vendor/bundle/install.log
  gosu jibjob rm -f /vendor/BUNDLER_RUNNING
  echo "Finished bundler install."
fi

# Prepare attachments (Rails public/system) directory
echo "Checking /app/public/system mount..."
if [[ ! -d /app/public/system ]]; then
  echo "WARNING: /app/public/system is not mounted."
else
  if [[ `stat -f -L -c %T /app/public/system` == "nfs" ]]; then
    echo "WARNING: /app/public/system is an NFS directory. It may not be writable."
  else
    chown -R jibjob:jibjob /app/public/system
    echo "/app/public/system is mounted."
  fi
fi

# Configure nginx
echo "Configuring nginx with RAILS_ENV=${RAILS_ENV}..."
erb /config/nginx.conf.erb > /opt/nginx/conf/nginx.conf
echo "Written config to /opt/ntinx/conf/nginx.conf"

# Invoke mode program
echo
case $PROGRAM in
  console)
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
    echo "Starting root shell..."
    exec bash -l
    ;;
  *)
    echo "Unknown mode...doing nothing."
    exit 1
    ;;
esac

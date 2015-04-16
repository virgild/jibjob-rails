#!/bin/bash

export PATH=${RUBY_PATH}:${PATH}

mode=${MODE:-console}
RAILS_ENV=${RAILS_ENV:-development}
HAS_APP=0

# Check app directory
if [[ -d /app ]]; then
  if [[ -e /app/bin/rails ]]; then
    HAS_APP=1
    echo "Found Rails app in /app"
  else
    echo "Cannot find Rails app in /app"
  fi
else
  echo "Cannot find /app"
fi

# Prepare app
if [[ $HAS_APP == "1" ]]; then
  # Initialize fonts
  echo "Copy fonts from assets and refreshing font cache..."
  cp -R /app/app/assets/fonts/print/* /opt/fonts/truetype/
  fc-cache -f

  # Prepare gems directory
  if [[ ! -d /vendor/bundle ]]; then
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
    gosu jibjob bundle install --path=/vendor/bundle
    gosu jibjob rm -f /vendor/BUNDLER_RUNNING
  fi

  # Prepare attachments (Rails public/system) directory
  if [[ ! -d /app/public/system ]]; then
    echo "WARNING: /app/public/system is not mounted."
  else
    if [[ `stat -f -L -c %T /app/public/system` == "nfs" ]]; then
      echo
      echo "***********************************************"
      echo "WARNING: /app/public/system is an NFS directory"
      echo "***********************************************"
      echo
    else
      chown -R jibjob:jibjob /app/public/system
    fi
  fi

  # Invoke mode program
  if [[ $mode == "console" ]]; then
    echo "Entering jibjob console..."
    exec gosu jibjob /bin/bash --login
  elif [[ $mode == "server" ]]; then
    echo "Starting server..."
  elif [[ $mode == "worker" ]]; then
    echo "Starting workers..."
    cd /app
    exec gosu jibjob bin/sidekiq "$@"
  elif [[ $mode == "rails" ]]; then
    cd /app
    exec gosu jibjob bin/rails "$@"
  elif [[ $mode == "su" ]]; then
    bash -l
  else
    echo "Unknown MODE...doing nothing."
    exit 1
  fi
else
  echo "No Rails app found. Reverting to console."
  echo "Entering jibjob console..."
  exec gosu jibjob /bin/bash --login
fi

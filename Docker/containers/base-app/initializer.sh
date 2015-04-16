#!/bin/bash

mode=${MODE:-console}

# Initialize app directory
if [[ -d /app ]]; then
  if [[ -e /app/bin/rails ]]; then
    export HAS_APP=1
    echo "Found Rails app in /app"
  else
    echo "Cannot find Rails app in /app"
  fi
else
  echo "Cannot find /app"
fi

# Initialize fonts
if [[ $HAS_APP == "1" ]]; then
  echo "Copy fonts from assets and refreshing font cache..."
  cp -R /app/app/assets/fonts/print/* /opt/fonts/truetype/
  fc-cache -f
fi

# Initialize gems
if [[ $HAS_APP == "1" ]]; then
  export PATH=${RUBY_PATH}:${PATH}
  if [[ $SKIP_BUNDLER == "1" ]]; then
    echo "(Skipping bundler...)"
  else
    echo "Running bundler..."
    gosu jibjob touch /vendor/BUNDLER_RUNNING
    cd /app
    gosu jibjob bundle install --path=/vendor/bundle
    gosu jibjob rm -f /vendor/BUNDLER_RUNNING
  fi
fi

if [[ $mode == "console" ]]; then
  echo "Entering jibjob console..."
  exec gosu jibjob /bin/bash --login
elif [[ $mode == "server" ]]; then
  echo "Starting server..."
  if [[ $HAS_APP == "1" ]]; then
    echo "server"
  else
    echo "No Rails app found. Cannot start server."
    exit 1
  fi
elif [[ $mode == "worker" ]]; then
  echo "Starting workers..."
  if [[ $HAS_APP == "1" ]]; then
    echo "worker"
  else
    echo "No Rails app found. Cannot start workers."
    exit 1
  fi
else
  echo "Unknown MODE...doing nothing."
  exit 1
fi

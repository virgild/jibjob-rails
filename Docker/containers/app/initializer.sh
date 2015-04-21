#!/bin/bash
set -e

export PATH=${RUBY_PATH}:${PATH}
export RAILS_ENV=${RAILS_ENV:-development}

PROGRAM=$1
PROGRAM_ARGS=${*:2:500}

MOUNTS_PASSING=1

# Initialize fonts
function prepare_fonts()
{
  printf "Copying fonts from /app/app/assets/fonts/print and refreshing font cache..."
  cp -R /app/app/assets/fonts/print/* /opt/fonts/truetype/
  fc-cache -f
  printf "done.\n"
}

function check_mount()
{
  printf "Checking mount: $1..."
  if [[ -e $1 ]]; then
    printf "OK\n"
  else
    printf "NOT FOUND\n"
    MOUNTS_PASSING=0
  fi
}

function main()
{
  # Check mounts
  check_mount "/app"
  check_mount "/app/public/system"
  check_mount "/app/config/database.yml"
  check_mount "/app/config/mailer.yml"
  check_mount "/vendor/bundle"

  if [[ $MOUNTS_PASSING -eq 0 ]]; then
    echo "ERROR: There are missing mounts"
    exit 1
  fi

  # Prepare app
  if [[ $RAILS_ENV != "development" ]]; then
    chown -R jibjob:jibjob /app
  fi

  # Chown the chown
  chown -R jibjob:jibjob /vendor

  # Handle attachments directory special cases
  if [[ `stat -f -L -c %T /app/public/system` == "nfs" ]]; then
    echo " - WARNING: /app/public/system is an NFS directory."
  else
    chown -R jibjob:jibjob /app/public/system
  fi

  # Run bundler
  printf "Running bundler..."
  gosu jibjob touch /vendor/BUNDLER_RUNNING
  cd /app
  if [[ $RAILS_ENV == "development" ]]; then
    gosu jibjob bundle install --path=/vendor/bundle --no-cache --shebang=${RUBY_PATH}/ruby &> /vendor/bundle/install.log
  else
    gosu jibjob bundle install --path=/vendor/bundle --deployment --without="development test" --no-cache --shebang=${RUBY_PATH}/ruby &> /vendor/bundle/install.log
  fi
  gosu jibjob rm -f /vendor/BUNDLER_RUNNING
  printf "OK\n"

  # Configure nginx
  printf "Configuring nginx with RAILS_ENV=${RAILS_ENV}..."
  erb /config/nginx.conf.erb > /opt/nginx/conf/nginx.conf
  printf "OK\n"

  # Prepare fonts
  prepare_fonts

  # Invoke mode program
  case $PROGRAM in
    console)
      echo
      echo "Starting jibjob shell (RAILS_ENV=${RAILS_ENV})..."
      exec gosu jibjob /bin/bash --login
      ;;
    server)
      echo
      echo "Starting nginx (RAILS_ENV=${RAILS_ENV})..."
      exec /opt/nginx/sbin/nginx
      ;;
    worker)
      echo
      echo "Running sidekiq (RAILS_ENV=${RAILS_ENV})..."
      cd /app
      exec gosu jibjob bin/sidekiq ${PROGRAM_ARGS}
      ;;
    *)
      echo
      echo "Unknown mode...doing nothing. (Modes are: console | server | worker)"
      exit 1
      ;;
  esac
}

main

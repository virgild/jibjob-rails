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
  if [[ (RAILS_ENV == "staging") || (RAILS_ENV == "production") ]]; then
    check_mount "/app/public/assets"
  fi
  check_mount "/app/vendor/bundle"

  if [[ $MOUNTS_PASSING -eq 0 ]]; then
    echo "ERROR: There are missing mounts"
    exit 1
  fi

  # Configure nginx (Remove after we configured our separate assets server)
  if [[ $RAILS_ENV != "development" ]]; then
    printf "Configuring nginx with RAILS_ENV=${RAILS_ENV}..."
    erb /config/nginx.conf.erb > /opt/nginx/conf/nginx.conf
    printf "OK\n"
  fi

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
      if [[ $RAILS_ENV == "development" ]]; then
        echo "Starting Rails server (RAILS_ENV=$RAILS_ENV)..."
        cd /app
        exec gosu jibjob bin/rails s -p 3000 -b 0.0.0.0
      else
        echo "Starting nginx (RAILS_ENV=${RAILS_ENV})..."
        exec /opt/nginx/sbin/nginx
      fi
      ;;
    worker)
      echo
      echo "Running sidekiq (RAILS_ENV=${RAILS_ENV})..."
      cd /app
      exec gosu jibjob bin/sidekiq ${PROGRAM_ARGS}
      ;;
    command)
      echo "Running command (RAILS_ENV=$RAILS_ENV)..."
      exec gosu jibjob ${PROGRAM_ARGS}
      ;;
    migrate)
      echo "Running DB migrations (RAILS_ENV=$RAILS_ENV)..."
      cd /app
      exec gosu jibjob bin/rake db:migrate
      ;;
    assets)
      echo "Precompiling assets (RAILS_ENV=$RAILS_ENV)..."
      cd /app
      exec gosu jibjob /usr/local/bin/precompile_assets.sh
      ;;
    *)
      echo
      echo "Unknown mode...doing nothing. (Modes are: console | server | worker)"
      exit 1
      ;;
  esac
}

main

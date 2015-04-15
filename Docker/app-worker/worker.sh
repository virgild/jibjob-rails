#!/bin/bash

# Sync the fonts
/bin/cp -R /app/app/assets/fonts/print/* /opt/fonts/truetype/
chown -R jibjob:jibjob /opt/fonts
gosu jibjob /usr/bin/fc-cache -f

# Run worker
export PATH=/opt/ruby/2.2.1/bin:${PATH}
cd /app
exec gosu jibjob bin/bundle exec sidekiq $@

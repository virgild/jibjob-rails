#!/bin/bash
set -e

export PATH=${RUBY_PATH}:${PATH}
export RAILS_ENV=${RAILS_ENV:-development}

echo "Running assets:precompile ($RAILS_ENV)"
cd /app
rake assets:precompile

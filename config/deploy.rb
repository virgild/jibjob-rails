# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'jibjob'
set :repo_url, 'git@github.com:virgild/jibjob-rails.git'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
# set :deploy_to, ENV['DEPLOY_DIRECTORY']
set :deploy_to, "/var/local/jibjob/rails"

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

set :keep_releases, 10

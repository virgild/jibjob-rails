# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'jibjob'
set :repo_url, 'git@github.com:virgild/jibjob-rails.git'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

set :deploy_to, "/var/local/jibjob/rails"

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

set :pty, false

# Default value for :log_level is :debug
set :log_level, :debug

set :keep_releases, 10

set :linked_files, fetch(:linked_files, []).push('.env', 'config/database.yml', 'config/secrets.yml', 'config/newrelic.yml', 'config/mailer.yml')

set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/assets')

set :default_path, {
  path: "/opt/ruby/2.2.2/bin:$PATH"
}

set :passenger_roles, :web
set :passenger_restart_command, 'touch'
set :passenger_restart_options, -> { "#{release_path}/tmp/restart.txt" }

set :sidekiq_role, [:worker]


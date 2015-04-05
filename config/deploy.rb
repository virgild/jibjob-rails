# config valid only for current version of Capistrano
lock '3.4.0'

set :application, 'jibjob'
set :repo_url, 'git@github.com:virgild/jibjob-rails.git'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }.call

# Default deploy_to directory is /var/www/my_app_name
set :deploy_to, ENV['DEPLOY_DIRECTORY']

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
# set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, fetch(:linked_files, []).push('.env', 'config/database.yml', 'config/secrets.yml', 'config/newrelic.yml', 'config/redis.yml', 'config/mailer.yml', 'config/sidekiq.yml')

# Default value for linked_dirs is []
set :linked_dirs, fetch(:linked_dirs, []).push('log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system', 'public/assets', 'node_modules')

# Default value for default_env is {}
if ENV['DEPLOY_ENV_PATH']
  set :default_env, { path: ENV['DEPLOY_ENV_PATH'] }
else
  set :default_env, {}
end

# NewRelic deploy notification params
set :newrelic_license_key, ENV['NEWRELIC_DEPLOY_LICENSE_KEY']

# Default value for keep_releases is 5
# set :keep_releases, 5

set :sidekiq_role, :worker
set :sidekiq_config, -> { File.join(shared_path, 'config', 'sidekiq.yml') }

namespace :deploy do
  after :restart, :clear_cache do
    on roles(:web), in: :groups, limit: 3, wait: 10 do
      # Here we can do anything such as:
      # within release_path do
      #   execute :rake, 'cache:clear'
      # end
    end
  end

  desc "Copy fonts"
  task :copy_fonts do
    on roles([:app, :worker]) do |host|
      info "Host: #{host}"
      execute :cp, "-R", "#{release_path}/app/assets/fonts/print/*", ENV['FONTS_INSTALL_DIR']
      execute "fc-cache", "-f -v"
    end
  end
end

after "deploy:normalize_assets", "deploy:copy_fonts"

# Notify NewRelic
after "deploy:updated", "newrelic:notice_deployment"
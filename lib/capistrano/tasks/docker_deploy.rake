# require 'json'
#
# # These are overrides to the standard cap deploy steps.
# # The basic idea is to skip the linked_files stuff
# # because we are mounting them as container volumes instead.
#
# namespace :deploy do
#
#   Rake::Task['deploy:migrate'].clear
#   task :migrate => [:set_rails_env] do
#     on primary fetch(:migration_role) do
#       conditionally_migrate = fetch(:conditionally_migrate)
#       info '[deploy:migrate] Checking changes in /db/migrate' if conditionally_migrate
#       if conditionally_migrate && test("diff -q #{release_path}/db/migrate #{current_path}/db/migrate")
#         info '[deploy:migrate] Skip `deploy:migrate` (nothing changed in db/migrate)'
#       else
#         info '[deploy:migrate] Run `rake db:migrate`'
#         within release_path do
#           with rails_env: fetch(:rails_env) do
#             execute :docker, "run --rm --name migrator",
#               "-v #{release_path}:/app",
#               "--volumes-from app_volumes",
#               "-e RAILS_ENV=#{fetch(:stage)}",
#               "jibjob/app:1.0.0",
#               "migrate"
#           end
#         end
#       end
#     end
#   end
#
#   after 'deploy:updated', 'deploy:migrate'
# end
#
# namespace :docker do
#   # Run assets precompile (post db migrate)
#
#   task :pull_app_image do
#     on release_roles(:all) do
#       execute :docker, "pull", "jibjob/app:1.0.0"
#     end
#   end
#
#   task :mount_app_volumes do
#     on release_roles(:all) do |server|
#       resJSON = capture(:curl, "--silent -X GET", "http://127.0.0.1:2375/containers/json?all=1")
#       if resJSON != ""
#         containers = JSON.parse(resJSON).map { |c| c["Names"][0] }
#       else
#         containers = []
#       end
#       has_volumes_container = containers.member?("/app_volumes")
#       unless has_volumes_container
#         execute :docker, "create", "--name app_volumes",
#           "-v #{shared_path.join('vendor/bundle')}:/app/vendor/bundle",
#           "-v #{shared_path.join('public/assets')}:/app/public/assets",
#           "-v #{shared_path.join('public/system')}:/app/public/system",
#           "-v #{shared_path.join('.env')}:/app/.env:ro",
#           "-v #{shared_path.join('config/database.yml')}:/app/config/database.yml:ro",
#           "-v #{shared_path.join('config/mailer.yml')}:/app/config/mailer.yml:ro",
#           "-v #{shared_path.join('config/newrelic.yml')}:/app/config/newrelic.yml:ro",
#           "-v #{shared_path.join('config/secrets.yml')}:/app/config/secrets.yml:ro",
#           "jibjob/app:1.0.0"
#       end
#     end
#   end
# end
#
# namespace :bundler do
#   Rake::Task['bundler:install'].clear
#   task :install do
#     on fetch(:bundle_servers) do
#       within release_path do
#         with fetch(:bundle_env_variables, {}) do
#           execute :docker, "run --rm --name bundler",
#             "-v #{release_path}:/app",
#             "--volumes-from app_volumes",
#             "-e RAILS_ENV=#{fetch(:stage)}",
#             "jibjob/app:1.0.0",
#             "command", "bundle install",
#             "--gemfile=/app/Gemfile",
#             "--path=/app/vendor/bundle",
#             "--no-cache",
#             "--deployment",
#             "--quiet"
#         end
#       end
#     end
#   end
# end
#
# before 'bundler:install', 'docker:pull_app_image'
# before 'bundler:install', 'docker:mount_app_volumes'

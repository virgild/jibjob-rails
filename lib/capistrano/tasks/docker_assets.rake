# namespace :deploy do
#   namespace :assets do
#     task :precompile do
#       on release_roles(fetch(:assets_roles)) do
#         execute :docker, "run --rm --name assets_compiler",
#           "-v #{release_path}:/app",
#           "--volumes-from app_volumes",
#           "-e RAILS_ENV=#{fetch(:stage)}",
#           "jibjob/app:1.0.0",
#           "assets"
#       end
#     end
#   end
#
#   after 'deploy:updated', 'deploy:assets:precompile'
# end
#
# namespace :load do
#   task :defaults do
#     set :assets_roles, fetch(:assets_roles, [:web])
#     set :assets_prefix, fetch(:assets_prefix, 'assets')
#   end
# end

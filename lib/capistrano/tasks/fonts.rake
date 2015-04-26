namespace :fonts do
  task :refresh_cache do
    on roles(:worker) do
      execute 'fc-cache', '-fv'
    end
  end
end

after 'deploy:published', 'fonts:refresh_cache'


set :deploy_to, ENV['DEPLOY_DIRECTORY']
set :user, ENV['DEPLOY_APP_USER']

set :default_env, {
  'PATH' => ENV['DEPLOY_ENV_PATH']
}

server ENV['DEPLOY_APP_SERVER'], user: ENV['DEPLOY_APP_USER'], roles: %w{web app db worker}

set :sidekiq_options_per_process, ["-c 20 --queue default --queue mailers --queue logging"]

set :ssh_options, {
  forward_agent: true,
  user: ENV['DEPLOY_APP_USER']
}

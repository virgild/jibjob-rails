set :deploy_to, "/apps/jibjob"
set :user, 'jibjob'

set :default_env, {
  'PATH' => "/opt/ruby/2.2.2/bin:$PATH"
}

server ENV['STAGING_HOST'], primary: true, roles: ['app', 'worker', 'db', 'web']

set :sidekiq_options_per_process, ["-c 10", "--queue default", "--queue mailers", "--queue logging"]

set :ssh_options, {
  forward_agent: true,
  user: 'jibjob'
}

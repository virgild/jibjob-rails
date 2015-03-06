Rails.application.configure do
  if Rails.env.test?
    config.active_job.queue_adapter = :test
  else
    config.active_job.queue_adapter = :sidekiq
  end
end
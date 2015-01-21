if Rails.env == 'development' and ENV['MINI_PROFILER'] == '1'
  require 'rack-mini-profiler'

  Rack::MiniProfilerRails.initialize!(Rails.application)
end
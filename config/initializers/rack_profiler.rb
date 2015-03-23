if Rails.env == 'development' and ENV['MINI_PROFILER'] == '1'
  require 'rack-mini-profiler'

  Rack::MiniProfilerRails.initialize!(Rails.application)
  Rack::MiniProfiler.config.storage = Rack::MiniProfiler::MemoryStore
end
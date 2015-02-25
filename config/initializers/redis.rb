if Rails.env.test?
  REDIS_POOL = ConnectionPool::Wrapper.new(size: 5, timeout: 4) { Redis.connect(url: ENV['JIBJOB_REDIS_TEST']) }
else
  REDIS_POOL = ConnectionPool::Wrapper.new(size: 5, timeout: 4) { Redis.connect(url: ENV['JIBJOB_REDIS']) }
end
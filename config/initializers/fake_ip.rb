if Rails.env != 'production'
  require File.join(Rails.root, 'lib/rack/fake_ip')

  Rails.configuration.middleware.insert_before ActionDispatch::RemoteIp, Rack::FakeIP
end
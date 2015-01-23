unless Rails.env == 'test'
  require 'rack/protection'

  Rails.configuration.middleware.use Rack::Protection
end
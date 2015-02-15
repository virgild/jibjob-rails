ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../config/environment', __FILE__)
require 'rails/test_help'

require 'capybara/poltergeist'
require 'capybara/rails'
require 'database_cleaner'

class ActiveSupport::TestCase
  # Setup all fixtures in test/fixtures/*.yml for all tests in alphabetical order.
  fixtures :all

  # Add more helper methods to be used by all tests here...
end

ActiveSupport::TestCase.use_transactional_fixtures = false

class ActionDispatch::IntegrationTest
  include Capybara::DSL
end

# Capybara
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
    debug: false,
    inspector: true,
    timeout: 60,
    js_errors: true,
    window_size: [1024, 900],
    phantomjs_options: ['--ignore-ssl-errors=yes'],
    port: 5000
  })
end

Capybara.configure do |config|
  config.javascript_driver = :poltergeist
end
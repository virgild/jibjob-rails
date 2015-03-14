# This file is copied to spec/ when you run 'rails generate rspec:install'
ENV['RAILS_ENV'] ||= 'test'
require 'spec_helper'
require File.expand_path('../../config/environment', __FILE__)
require 'rspec/rails'
require 'rspec/active_job'
# Add additional requires below this line. Rails is not loaded until this point!
require 'sidekiq/testing'
require 'capybara/rails'
require 'capybara/rspec'
require 'capybara/poltergeist'

# Requires supporting ruby files with custom matchers and macros, etc, in
# spec/support/ and its subdirectories. Files matching `spec/**/*_spec.rb` are
# run as spec files by default. This means that files in spec/support that end
# in _spec.rb will both be required and run as specs, causing the specs to be
# run twice. It is recommended that you do not name files matching this glob to
# end with _spec.rb. You can configure this pattern with the --pattern
# option on the command line or in ~/.rspec, .rspec or `.rspec-local`.
#
# The following line is provided for convenience purposes. It has the downside
# of increasing the boot-up time by auto-requiring all files in the support
# directory. Alternatively, in the individual `*_spec.rb` files, manually
# require only the support files necessary.
#
# Dir[Rails.root.join('spec/support/**/*.rb')].each { |f| require f }

# Checks for pending migrations before tests are run.
# If you are not using ActiveRecord, you can remove this line.
ActiveRecord::Migration.maintain_test_schema!

RSpec.configure do |config|
  # Remove this line if you're not using ActiveRecord or ActiveRecord fixtures
  config.fixture_path = "#{::Rails.root}/spec/fixtures"

  # Enable Travis CI exclusions
  if ENV['TRAVIS']
    config.filter_run_excluding(no_travis: true)
  end

  # If you're not using ActiveRecord, or you'd prefer not to run each of your
  # examples within a transaction, remove the following line or assign false
  # instead of true.
  config.use_transactional_fixtures = false

  # RSpec Rails can automatically mix in different behaviours to your tests
  # based on their file location, for example enabling you to call `get` and
  # `post` in specs under `spec/controllers`.
  #
  # You can disable this behaviour by removing the line below, and instead
  # explicitly tag your specs with their type, e.g.:
  #
  #     RSpec.describe UsersController, :type => :controller do
  #       # ...
  #     end
  #
  # The different available types are documented in the features, such as in
  # https://relishapp.com/rspec/rspec-rails/docs
  config.infer_spec_type_from_file_location!

  config.include ActiveJob::TestHelper
  config.include Capybara::DSL

  config.before(:suite) do
    DatabaseCleaner.strategy = :truncation, {except: ['schema_migrations']}
  end

  config.before(:each) do
    DatabaseCleaner.start
  end

  config.after(:each) do
    DatabaseCleaner.clean
    FileUtils.rm_rf(Dir["#{Rails.root}/public/test"])
    ActiveJob::Base.queue_adapter.enqueued_jobs = []
    ActiveJob::Base.queue_adapter.performed_jobs = []
    Rails.cache.clear
    REDIS_POOL.flushdb
  end

  # Helper method for waiting on jQuery ajax requests
  # TODO: Extract into module
  def wait_for_ajax
    counter = 0
    while page.execute_script("return $.active").to_i > 0
      counter += 1
      sleep(0.1)
      raise "AJAX request took longer than 5 seconds." if counter >= 50
    end
  end

  def save_screen
    page.save_screenshot("page-#{Time.now.to_i}.png", full: true)
  end
end

# Capybara
Capybara.register_driver :poltergeist do |app|
  Capybara::Poltergeist::Driver.new(app, {
    debug: false,
    inspector: false,
    timeout: 60,
    js_errors: true,
    window_size: [1024, 900],
    phantomjs_options: ['--ignore-ssl-errors=yes']
  })
end

Capybara.javascript_driver = :poltergeist
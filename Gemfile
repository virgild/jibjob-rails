source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.5.1'
# Use postgresql as the database for Active Record
gem 'pg'
# Use SCSS for stylesheets
gem 'sass-rails', '~> 5.0'
# Use Uglifier as compressor for JavaScript assets
gem 'uglifier', '>= 1.3.0'
# Use jquery as the JavaScript library
gem 'jquery-rails'
# Build JSON APIs with ease. Read more: https://github.com/rails/jbuilder
gem 'jbuilder', '~> 2.0'
# bundle exec rake doc:rails generates the API under doc/api.
gem 'sdoc', '~> 0.4.0', group: :doc
gem 'execjs'

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
gem 'capistrano-rails', group: :development
gem 'capistrano-sidekiq', group: :development
gem 'capistrano-passenger', '= 0.0.5', group: :development

gem 'haml-rails'
gem 'sass'
gem 'dalli'
gem 'hiredis'
gem 'redis', require: ['redis', 'redis/connection/hiredis']
gem 'connection_pool'
gem 'oj'
gem 'sidekiq'
gem 'sidekiq-failures'
gem 'sinatra', require: false
gem 'will_paginate'
gem 'whenever', require: false
gem 'gon'
gem 'geokit-rails'
gem 'tzinfo-data'
gem 'browser'
gem 'google-analytics-rails'
gem 'react-rails'
gem 'autoprefixer-rails'

gem 'active_type'
gem 'active_model_serializers'
gem 'resumetools'
gem 'wicked_pdf'
gem 'render_anywhere', require: false
gem 'paperclip'
gem 'aws-sdk-v1'
gem 'sanitize'
gem 'pragmatic_segmenter'
gem 'encrypted_strings'
gem 'omniauth-facebook'
gem 'omniauth-twitter'
gem 'omniauth-google-oauth2'

gem 'dotenv-rails'
gem 'rack-protection'
gem 'newrelic_rpm'

group :development do
  gem 'annotate'
  gem 'pry-rails'
  # Access an IRB console on exception pages or by using <%= console %> in views
  # gem 'web-console', '~> 2.0'
  gem 'rack-mini-profiler', require: false
  gem 'quiet_assets'
  gem 'better_errors'
  gem 'binding_of_caller'
  gem 'awesome_print'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'thin'
  gem 'rspec-rails', '~> 3.0'
  gem 'rspec-activejob'
  gem 'faker'
end

group :test do
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner'
  gem 'codeclimate-test-reporter', require: false
  gem 'timecop'
  gem 'wkhtmltopdf-binary-edge', '~> 0.12.2.1', require: false
end

source 'https://rubygems.org'

# Bundle edge Rails instead: gem 'rails', github: 'rails/rails'
gem 'rails', '4.2.0'
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
gem 'therubyracer', platforms: :ruby

# Use ActiveModel has_secure_password
gem 'bcrypt', '~> 3.1.7'

# Use Capistrano for deployment
gem 'capistrano-rails', group: :development
gem 'capistrano-sidekiq', group: :development
gem 'capistrano-passenger', group: :development

gem 'haml-rails'
gem 'sass'
gem 'dalli'
gem 'hiredis'
gem 'redis', require: ['redis', 'redis/connection/hiredis']
gem 'connection_pool'
gem 'oj'
gem 'sidekiq'
gem 'sinatra', require: false
gem 'will_paginate'
gem 'whenever', require: false
gem 'gon'
gem 'geokit-rails'
gem 'tzinfo-data'

gem 'momentjs-rails'
gem 'react-rails', '~> 1.0.0.pre', github: 'reactjs/react-rails'
gem 'd3-rails'
gem 'bootstrap-sass', '~> 3.3.2'
gem 'autoprefixer-rails'

gem 'active_type'
gem 'active_model_serializers'
gem 'resumetools'
gem 'paperclip'
gem 'sanitize'
gem 'pragmatic_segmenter'

gem 'dotenv-rails'
gem 'rack-protection'
#gem 'newrelic_rpm'

group :development do
  # gem 'better_errors'
  # gem 'binding_of_caller'
  gem 'annotate'
  gem 'pry-rails'
  # Access an IRB console on exception pages or by using <%= console %> in views
  gem 'web-console', '~> 2.0'
  gem 'rack-mini-profiler', require: false
  gem 'quiet_assets'
end

group :development, :test do
  # Call 'byebug' anywhere in the code to stop execution and get a debugger console
  gem 'byebug'
  gem 'timecop'
  gem 'puma'
  gem 'rspec-rails', '~> 3.0'
end

group :test do
  gem 'capybara'
  gem 'poltergeist'
  gem 'database_cleaner', '~> 1.3.0' # Version 1.4.0 has bug where 'except' tables do not work.
  #gem 'minitest-documentation'
end

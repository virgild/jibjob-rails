require File.expand_path('../boot', __FILE__)

require 'rails/all'

# Require the gems listed in Gemfile, including any gems
# you've limited to :test, :development, or :production.
Bundler.require(*Rails.groups)

module JibJob
  class Application < Rails::Application
    # Settings in config/environments/* take precedence over those specified here.
    # Application configuration should go into files in config/initializers
    # -- all .rb files in that directory are automatically loaded.

    # Set Time.zone default to the specified zone and make Active Record auto-convert to this zone.
    # Run "rake -D time" for a list of tasks for finding time zone names. Default is UTC.
    # config.time_zone = 'Central Time (US & Canada)'

    # The default locale is :en and all translations from config/locales/*.rb,yml are auto loaded.
    # config.i18n.load_path += Dir[Rails.root.join('my', 'locales', '*.{rb,yml}').to_s]
    # config.i18n.default_locale = :de

    # Do not swallow errors in after_commit/after_rollback callbacks.
    config.active_record.raise_in_transactional_callbacks = true

    # Set SQL schema dump format
    config.active_record.schema_format = :sql

    # Set ActiveJob queue delimiter
    config.active_job.queue_name_delimiter = '.'

    # Set cache store
    if ENV['MEMCACHED_SERVERS']
      memcache_servers = ENV['MEMCACHED_SERVERS'].split(' ')
    else
      memcache_servers = ['localhost:11211']
    end
    config.cache_store = :dalli_store, *memcache_servers

    # Add bower components path
    root.join('vendor', 'assets', 'components').to_s.tap do |bower_path|
      config.sass.load_paths << bower_path
      config.assets.paths << bower_path
    end

    # ReactJS
    config.react.jsx_transform_options = {
      harmony: true,
      strip_types: true
    }
    config.react.addons = true

    # Unauthorized error
    config.action_dispatch.rescue_responses.merge!(
      'Errors::Unauthorized' => :unauthorized
    )

    # Autoload on lib dir
    config.autoload_paths << Rails.root.join('lib')

    # Set server tag
    # TODO: Adapt this to docker container
    hostname = `hostname`.strip!
    pid = $$

    config.action_dispatch.default_headers = {
      'X-Worker-Pants' => "#{hostname}-#{pid}"
    }

    # Mailer config
    mailer_config = YAML.load(ERB.new(File.read("config/mailer.yml")).result)[Rails.env]
    config.action_mailer.merge!(mailer_config)

    # Set logger
    if !!ENV['RAILS_LOG_TO_FILE']
      Rails.logger = Logger.new(STDOUT)
    end
  end
end

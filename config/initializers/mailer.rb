mailer_config = YAML.load_file("config/mailer.yml")[Rails.env]

Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = mailer_config[:smtp]
Rails.application.config.action_mailer.default_url_options = mailer_config[:default_url_options]
Rails.application.config.action_mailer.delivery_method = :smtp
Rails.application.config.action_mailer.smtp_settings = YAML.load_file("config/mailer.yml")[Rails.env]
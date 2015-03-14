Rails.application.config.middleware.use OmniAuth::Builder do
  configure do |config|
    config.path_prefix = '/app/auth'
  end

  provider :facebook, ENV['FACEBOOK_KEY'], ENV['FACEBOOK_SECRET'], {
    scope: 'email'
  }

  provider :twitter, ENV['TWITTER_KEY'], ENV['TWITTER_SECRET']

  provider :google_oauth2, ENV['GOOGLE_CLIENT_KEY'], ENV['GOOGLE_CLIENT_SECRET'], {
    name: "google",
    scope: "email",
    prompt: "select_account"
  }
end

OmniAuth.config.logger = Rails.logger

if Rails.env.test?
  OmniAuth.config.test_mode = true
end
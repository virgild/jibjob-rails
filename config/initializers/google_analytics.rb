if Rails.env.production? && ENV['GOOGLE_ANALYTICS_ID']
  GA.tracker = ENV['GOOGLE_ANALYTICS_ID']
end
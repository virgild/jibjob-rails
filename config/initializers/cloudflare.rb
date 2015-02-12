require File.join(Rails.root, 'lib/rack/cloudflare_ip')

Rails.configuration.middleware.insert_before ActionDispatch::RemoteIp, Rack::CloudflareIp
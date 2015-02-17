module GeokitOverrides
  extend ActiveSupport::Concern

  included do
    skip_before_filter :set_geokit_domain
    skip_before_filter :geocode_ip_address

    before_filter :set_fake_ip_cookie
  end

  def set_fake_ip_cookie
    if params[:_ip_address]
      cookies[:_ip_address] = params[:_ip_address]
    end
  end
end
module GeokitOverrides
  extend ActiveSupport::Concern

  included do
    skip_before_filter :set_geokit_domain
    skip_before_filter :geocode_ip_address
  end

end
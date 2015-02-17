class PublicationViewSerializer < BaseSerializer
  attributes :ip_addr, :url, :referrer, :user_agent, :created_at
  attributes :lat, :lng, :city, :state, :country

  def ip_addr
    object.ip_addr.to_s
  end

  def created_at
    object.created_at.in_time_zone(object.timezone)
  end
end
# == Schema Information
#
# Table name: publication_views
#
#  id         :integer          not null, primary key
#  resume_id  :integer          not null
#  ip_addr    :inet             not null
#  url        :string           not null
#  referrer   :string
#  user_agent :string
#  created_at :datetime         not null
#  lat        :decimal(9, 6)
#  lng        :decimal(9, 6)
#  city       :string
#  state      :string
#  country    :string
#
# Indexes
#
#  index_publication_views_on_resume_id  (resume_id)
#

class PublicationViewSerializer < BaseSerializer
  attributes :ip_addr, :url, :referrer, :user_agent, :created_at
  attributes :lat, :lng, :city, :state, :country, :location

  def ip_addr
    object.ip_addr.to_s
  end

  def created_at
    object.created_at.in_time_zone(object.timezone).strftime("%B %d, %Y %l:%M %p")
  end

  def location
    value = [city, state, country].compact.join(', ')
    value.blank? ? "Unknown" : value
  end
end

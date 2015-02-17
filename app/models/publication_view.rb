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

class PublicationView < ActiveRecord::Base
  validates :resume_id, presence: true
  validates :ip_addr, presence: true
  validates :url, presence: true

  belongs_to :resume
  has_one :user, through: :resume

  before_save :geocode_ip, on: :create

  def timezone
    user.timezone
  end

  private

  def geocode_ip
    loc = Geokit::Geocoders::MultiGeocoder.geocode(ip_addr.to_s)
    if loc.success?
      self.city = loc.city
      self.country = loc.country_code
      self.state = loc.state
      self.lat = loc.lat
      self.lng = loc.lng
    end
  end
end

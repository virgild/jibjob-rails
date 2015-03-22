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
  attr_accessor :skip_geocode

  validates :resume_id, presence: true
  validates :ip_addr, presence: true
  validates :url, presence: true

  belongs_to :resume, counter_cache: true
  has_one :user, through: :resume

  scope :in_range, -> (time_start, time_end) { where('created_at < ? and created_at > ?', time_start, time_end) }

  before_save :geocode_ip, on: :create, unless: :skip_geocode
  after_save :increment_hour_stat, on: :create
  after_save :increment_week_stat, on: :create

  def timezone
    user.timezone
  end

  def refresh_stat
    increment_hour_stat
    increment_week_stat
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

  def stats_key
    resume.publication_view_stats_key
  end

  def stat_key_for_hour
    created_at.strftime("day-%Y-%j-%H")
  end

  def stat_key_for_week
    "week-#{created_at.year}-#{created_at.to_date.cweek}"
  end

  def increment_hour_stat
    REDIS_POOL.hincrby(stats_key, stat_key_for_hour, 1)
  end

  def increment_week_stat
    REDIS_POOL.hincrby(stats_key, stat_key_for_week, 1)
  end
end

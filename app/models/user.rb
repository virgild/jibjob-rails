# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  email           :string
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  default_role    :string
#  timezone        :string
#  auth_provider   :string
#  auth_uid        :string
#  auth_name       :string
#  auth_token      :string
#  auth_secret     :string
#  auth_expires    :datetime
#
# Indexes
#
#  index_users_on_auth_provider               (auth_provider)
#  index_users_on_auth_provider_and_auth_uid  (auth_provider,auth_uid)
#  index_users_on_email                       (email)
#  index_users_on_username                    (username)
#

class User < ActiveRecord::Base
  include CacheFlow

  has_secure_password

  has_many :resumes, dependent: :destroy
  has_many :activity_logs, dependent: :destroy
  has_one :signup, dependent: :destroy
  has_one :signup_confirmation, dependent: :destroy
  has_one :password_recovery, dependent: :destroy, inverse_of: :user

  validates :username, presence: true, uniqueness: true
  validates :default_role, presence: true

  validates_exclusion_of :username, in: ['admin', 'test', 'auth', 'oauth']
  validates_inclusion_of :default_role, in: ['user', 'admin']

  after_initialize :set_default_role

  scope :oauth_signups, -> { where.not(auth_provider: nil) }
  scope :password_recoverable, -> { where(auth_provider: nil).where.not(email: nil) }
  scope :with_owner, -> (user_id) { where(id: user_id) }

  MAX_RESUMES_COUNT ||= 10

  has_cache :resume_list, with_elements: {
    count: -> (user) { user.resumes.count },
    views: -> (user) { user.cached_total_resume_views },
    last_update: -> (user) { user.resumes.most_recently_updated.try(:updated_at).to_i }
  }

  def signup_confirmed?
    signup_confirmation &&
      signup_confirmation.confirmed_at &&
      signup_confirmation.confirmed_at <= DateTime.now
  end

  def available_resumes_count
    MAX_RESUMES_COUNT - resumes.count
  end

  def has_available_resume_slot?
    available_resumes_count > 0
  end

  def oauth_signup?
    self.auth_provider.present?
  end

  def can_recover_password?
    !self.oauth_signup?
  end

  def descriptor
    if oauth_signup?
      auth_name
    else
      username
    end
  end

  def cached_total_resume_views
    REDIS_POOL.get("user-#{self.id}-cached_total_resume_views").try(:to_i) || 0
  end

  def increment_cached_total_resume_views
    REDIS_POOL.incr("user-#{self.id}-cached_total_resume_views")
  end

  def is_admin?
    self.default_role == 'admin'
  end

  private

  def set_default_role
    self.default_role ||= 'user'
  end
end

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  default_role    :string
#  timezone        :string
#

class User < ActiveRecord::Base
  has_secure_password

  has_many :resumes, -> { order("id") }, dependent: :destroy
  has_one :signup, dependent: :destroy
  has_one :signup_confirmation, dependent: :destroy
  has_one :password_recovery, dependent: :destroy, inverse_of: :user

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :default_role, presence: true

  validates_exclusion_of :username, in: ['admin', 'test']
  validates_format_of :username, with: /\A[A-Za-z][A-Za-z0-9_]{4}[A-Za-z0-9_]+\Z/
  validates_inclusion_of :default_role, in: ['user', 'admin']

  after_initialize :set_default_role

  MAX_RESUMES_COUNT = 10

  def signup_confirmed?
    signup_confirmation &&
      signup_confirmation.confirmed_at &&
      signup_confirmation.confirmed_at <= DateTime.now
  end

  def to_param
    self.username
  end

  def available_resumes_count
    MAX_RESUMES_COUNT - resumes.count
  end

  def has_available_resume_slot?
    available_resumes_count > 0
  end

  private

  def set_default_role
    self.default_role ||= 'user'
  end
end

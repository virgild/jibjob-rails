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
#  timezone        :decimal(, )
#

class User < ActiveRecord::Base
  include User::Param

  has_secure_password
  has_many :resumes, dependent: :destroy
  has_many :publications, dependent: :destroy
  has_one :signup, dependent: :destroy
  has_one :signup_confirmation, dependent: :destroy

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :default_role, presence: true

  after_initialize :set_default_role

  def signup_confirmed?
    signup_confirmation &&
      signup_confirmation.confirmed_at &&
      signup_confirmation.confirmed_at <= DateTime.now
  end

  private

  def set_default_role
    self.default_role ||= 'user'
  end
end

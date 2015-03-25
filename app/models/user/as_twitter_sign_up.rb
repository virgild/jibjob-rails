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

class User::AsTwitterSignUp < ActiveType::Record[User]
  include WithSignupData

  validates_presence_of :auth_provider
  validates_presence_of :auth_uid
  validates_inclusion_of :auth_provider, in: ['twitter']

  before_validation :set_username, on: :create
  before_validation :set_random_password, on: :create

  default_scope { where(auth_provider: 'twitter') }

  def self.new_from_auth_hash(auth_hash)
    user = self.new(
      auth_uid: auth_hash.uid,
      auth_name: auth_hash.info.nickname
    )
  end

  private

  def set_username
    self.username = "tw:#{self.auth_uid}"
  end

  def set_random_password
    self.password = SecureRandom.hex(16)
  end
end

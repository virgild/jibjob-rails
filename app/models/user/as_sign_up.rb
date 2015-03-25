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

class User::AsSignUp < ActiveType::Record[User]
  include WithSignupData

  attribute :terms, :string

  validates_format_of :username, with: /\A[A-Za-z][A-Za-z0-9_]{4}[A-Za-z0-9_]+\Z/
  validates_acceptance_of :terms
  validates_presence_of :email
  validates_uniqueness_of :email

  after_commit :create_signup_confirmation, on: :create
  after_commit :send_signup_confirmation_email, on: :create

  private

  def create_signup_confirmation
    confirmation = self.build_signup_confirmation
    confirmation.save
  end

  def send_signup_confirmation_email
    AccountsMailer.signup_confirmation(self).deliver_later
  end
end

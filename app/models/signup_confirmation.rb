# == Schema Information
#
# Table name: signup_confirmations
#
#  user_id      :integer          not null, primary key
#  token        :string           not null
#  confirmed_at :datetime
#
# Indexes
#
#  index_signup_confirmations_on_token  (token) UNIQUE
#

class SignupConfirmation < ActiveRecord::Base
  belongs_to :user

  validates :user_id, presence: true, uniqueness: true
  validates :token, presence: true, uniqueness: true

  before_validation :ensure_token_string_exists

  private

  def ensure_token_string_exists
    self.token ||= SecureRandom.hex(16)
  end
end

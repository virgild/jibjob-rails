# == Schema Information
#
# Table name: signup_confirmations
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  token        :string           not null
#  confirmed_at :datetime
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

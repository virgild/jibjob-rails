# == Schema Information
#
# Table name: password_recoveries
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  token      :string           not null
#  created_at :datetime
#

class PasswordRecovery < ActiveRecord::Base
  belongs_to :user, inverse_of: :password_recovery

  validates_presence_of :token
  validates_uniqueness_of :token

  before_validation :ensure_present_token, on: :create

  private

  def ensure_present_token
    self.token ||= SecureRandom.hex(16)
    true
  end
end

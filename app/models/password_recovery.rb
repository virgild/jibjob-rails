# == Schema Information
#
# Table name: password_recoveries
#
#  user_id    :integer          not null, primary key
#  token      :string           not null
#  created_at :datetime
#

class PasswordRecovery < ActiveRecord::Base
  belongs_to :user

  validates_presence_of :token
  validates_uniqueness_of :token

  before_validation :ensure_present_token, on: :create

  private

  def ensure_present_token
    self.token ||= SecureRandom.hex(16)
  end
end
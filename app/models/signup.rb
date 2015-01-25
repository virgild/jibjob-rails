# == Schema Information
#
# Table name: signups
#
#  user_id    :integer          not null, primary key
#  ip_address :inet
#  user_agent :string
#  extras     :json
#  created_at :datetime         not null
#

class Signup < ActiveRecord::Base
  belongs_to :user

  validates :user_id, uniqueness: true
end

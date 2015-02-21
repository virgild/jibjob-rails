# == Schema Information
#
# Table name: signups
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  ip_address :inet
#  user_agent :string
#  extras     :json
#  created_at :datetime         not null
#

class Signup < ActiveRecord::Base
  belongs_to :user

  validates :user_id, uniqueness: true
end

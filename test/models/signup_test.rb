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

require 'test_helper'

class SignupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: signup_confirmations
#
#  user_id      :integer          not null, primary key
#  token        :string           not null
#  confirmed_at :datetime
#

require 'test_helper'

class SignupConfirmationTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

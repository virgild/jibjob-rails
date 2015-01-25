# == Schema Information
#
# Table name: user_signups
#
#  user_id   :integer          not null
#  signup_id :integer          not null
#
# Indexes
#
#  index_user_signups_on_user_id_and_signup_id  (user_id,signup_id) UNIQUE
#

require 'test_helper'

class UserSignupTest < ActiveSupport::TestCase
  # test "the truth" do
  #   assert true
  # end
end

# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  default_role    :string
#  timezone        :string
#

require 'test_helper'

class UserTest < ActiveSupport::TestCase

  test "create signup_confirmation on create" do
    user = User::AsSignUp.new(
      username: 'test_user1',
      email: 'test_user1@example.com',
      password: 'testpass',
      terms: '1'
    )

    assert user.save
    assert_not_nil user.signup_confirmation
    assert_nil user.signup_confirmation.confirmed_at
    assert_not user.signup_confirmation.token.blank?
  end

end

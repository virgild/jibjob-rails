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

require 'test_helper'

class UsersControllerTest < ActionController::TestCase

  test "user signup and its effects" do
    get :new
    assert_response :success

    post :create, user: {
      username: 'test_user',
      email: 'test_user@example.com',
      password: 'testpass',
      password_confirmation: 'testpass',
      terms: '1'
    }
    user = assigns(:user)
    assert_not_nil user
    assert_redirected_to user_resumes_path(user)

    assert_equal user.default_role, 'user'

    assert_not_nil user.signup_confirmation
  end
end

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  describe "after user signup" do
    before(:each) do
      get :new, { :_wallaby => 1}
      assert_response :success

      post :create, user: {
        username: 'test_user',
        email: 'test_user@example.com',
        password: 'testpass',
        password_confirmation: 'testpass',
        terms: '1'
      }
    end

    it "redirects to resumes page" do
      user = assigns(:user)
      expect(user).to_not be_nil

      expect(response).to redirect_to(user_resumes_path(user))
    end
  end
end

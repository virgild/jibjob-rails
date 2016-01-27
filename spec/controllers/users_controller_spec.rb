# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  email           :string
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  timezone        :string
#  default_role    :string
#  auth_provider   :string
#  auth_uid        :string
#  auth_name       :string
#  auth_token      :string
#  auth_secret     :string
#  auth_expires    :datetime
#
# Indexes
#
#  index_users_on_auth_provider               (auth_provider)
#  index_users_on_auth_provider_and_auth_uid  (auth_provider,auth_uid)
#  index_users_on_email                       (email)
#  index_users_on_username                    (username)
#

require 'rails_helper'

RSpec.describe UsersController, type: :controller do
  fixtures :all

  describe "after user signup" do
    before(:each) do
      get :new
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

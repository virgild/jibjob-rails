require 'rails_helper'

RSpec.describe Auth::FacebookController, type: :controller do
  fixtures :all

  before :each do
    OmniAuth.config.mock_auth[:facebook] = nil
  end

  context "#callback" do
    context "with valid auth" do
      before :each do
        OmniAuth.config.mock_auth[:facebook] = OmniAuth::AuthHash.new({
          provider: 'facebook',
          uid: '1234567890',
          info: {
            email: "facebook-test@example.com",
            first_name: "Thomas",
            last_name: "Seeker"
          },
          credentials: {
            token: 'facebook-test-token',
            expires: true,
            expires_at: 1.month.from_now.to_i
          }
        })

        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:facebook]

        get :callback
      end

      it "creates valid user" do
        expect(assigns(:user)).to be_valid
      end

      it "redirects to resumes page" do
        expect(response).to redirect_to user_resumes_path(assigns(:user))
      end

      it "logs in the facebook user" do
        expect(session['auth.default.user']).to eq assigns(:user).id
      end
    end
  end

end
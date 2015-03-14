require 'rails_helper'

RSpec.describe Auth::TwitterController, type: :controller do
  fixtures :all

  before :each do
    OmniAuth.config.mock_auth[:twitter] = nil
  end

  context "#callback" do
    context "with valid auth" do
      before :each do
        OmniAuth.config.mock_auth[:twitter] = OmniAuth::AuthHash.new({
          provider: 'twitter',
          uid: '1234567890',
          info: {
            nickname: 'thomas',
            location: 'Canada',
            description: '',
            image: ''
          },
          credentials: {
            token: 'twitter-test-token',
            secret: 'twitter-test-secret'
          }
        })

        request.env["omniauth.auth"] = OmniAuth.config.mock_auth[:twitter]

        get :callback
      end

      it "creates valid user" do
        expect(assigns(:user)).to be_valid
      end

      it "redirects to resumes page" do
        expect(response).to redirect_to user_resumes_path(assigns(:user))
      end

      it "logs in the twitter user" do
        expect(session['auth.default.user']).to eq assigns(:user).id
      end
    end
  end

end
require 'rails_helper'

RSpec.describe User::AsTwitterSignUp, type: :model do
  context "new_from_auth_hash()" do
    let(:auth_hash) {
      double("auth_hash", {
        uid: '1234567890',
        credentials: double('credentials', {
          token: 'token123',
          secret: 'twitter-secret'
        }),
        info: double('info', {
          email: 'testtwitteruser@example.com',
          nickname: 'thomas_seeker'
        })
      })
    }
    let(:user) { User::AsTwitterSignUp.new_from_auth_hash(auth_hash) }

    it_behaves_like "oauth signup"
  end
end
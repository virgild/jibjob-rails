require 'rails_helper'

RSpec.describe User::AsGoogleSignUp, type: :model do
  context "new_from_auth_hash()" do
    let(:auth_hash) {
      double("auth_hash", {
        uid: '1234567890',
        credentials: double('credentials', {
          token: 'token123',
          expires_at: 30.days.from_now.to_i
        }),
        info: double('info', {
          email: 'testgoogleuser@example.com',
          name: 'Test User'
        })
      })
    }
    let(:user) { User::AsGoogleSignUp.new_from_auth_hash(auth_hash) }

    it_behaves_like "oauth signup"
  end
end
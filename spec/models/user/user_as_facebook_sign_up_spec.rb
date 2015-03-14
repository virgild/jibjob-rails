require 'rails_helper'

RSpec.describe User::AsFacebookSignUp, type: :model do
  context "new_from_auth_hash()" do
    let(:auth_hash) {
      double("auth_hash", {
        uid: '1234567890',
        credentials: double('credentials', {
          token: 'token123',
          expires_at: 30.days.from_now.to_i
        }),
        info: double('info', {
          email: 'testfacebookuser@example.com',
          name: "Thomas Seeker"
        })
      })
    }
    let(:user) { User::AsFacebookSignUp.new_from_auth_hash(auth_hash) }

    it_behaves_like "oauth signup"
  end
end
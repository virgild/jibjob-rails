require 'rails_helper'

RSpec.describe User, type: :model do
  context "after creation" do
    before(:each) do
      @user = User::AsSignUp.new(
        username: 'test_user1',
        email: 'test_user1@example.com',
        password: 'testpass',
        password_confirmation: 'testpass',
        terms: '1'
      )
    end

    it "creates a signup confirmation" do
      expect(@user.save).to be true
      expect(@user.signup_confirmation).not_to be_nil
      expect(@user.signup_confirmation.id).not_to be_nil
      expect(@user.signup).to be_nil
    end

    it "creates a signup record when provided" do
      @user.signup_data = {
        ip_address: '127.0.0.1',
        user_agent: 'test browser 1.0'
      }

      expect(@user.save).to eq(true)
      expect(@user.signup).not_to be_nil
    end
  end
end

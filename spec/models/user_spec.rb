require 'rails_helper'

RSpec.describe User, :type => :model do
  describe "fresh initialize" do
    before do
      @user = User.new(
        username: 'test_user',
        email: 'test_user@example.com',
        password: 'test_password',
        password_confirmation: 'test_password'
      )
    end

    it "should have standard properties" do
      expect(@user).to be_valid
      expect(@user.save).to eq(true)
    end

    it "should have empty resumes" do
      expect(@user.resumes).to be_empty
    end
  end
end
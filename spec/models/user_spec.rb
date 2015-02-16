require 'rails_helper'

RSpec.describe User, type: :model do
  context "attributes and validation" do
    let (:user) { User.new }

    before(:each) do
      user.save
    end

    it "requires a username" do
      expect(user.errors[:username]).to_not be_empty
    end

    it "requires an email" do
      expect(user.errors[:email]).to_not be_empty
    end

    it "requires a password" do
      expect(user.errors[:password]).to_not be_empty
    end

    it "requires a default role" do
      user.default_role = ''
      user.save
      expect(user.errors[:default_role]).to_not be_empty
    end

    it "has resumes attribute" do
      expect(user.resumes).to be_empty
    end

    it "has a signup attribute" do
      expect(user.signup).to be_nil
    end

    it "has a blank signup confirmation attribute" do
      expect(user.signup_confirmation).to be_nil
    end
  end

  context "username validation" do
    let (:user) { User.new(email: 'testuser@example.com', password: 'testpass', password_confirmation: 'testpass') }

    context "valid usernames" do
      example "turtleman" do
        user.username = 'turtleman'
        expect(user).to be_valid
      end

      example "moon_dogg_23" do
        user.username = 'moon_dogg_23'
        expect(user).to be_valid
      end
    end

    context "invalid usernames" do
      example "admin" do
        user.username = 'admin'
        expect(user).to_not be_valid
        expect(user.errors[:username]).to_not be_empty
      end

      example "test" do
        user.username = 'test'
        expect(user).to_not be_valid
        expect(user.errors[:username]).to_not be_empty
      end

      example "_myusername" do
        user.username = '_myusername'
        expect(user).to_not be_valid
        expect(user.errors[:username]).to_not be_empty
      end

      example "my.username" do
        user.username = 'my.username'
        expect(user).to_not be_valid
        expect(user.errors[:username]).to_not be_empty
      end

      example "my username" do
        user.username = 'my username'
        expect(user).to_not be_valid
        expect(user.errors[:username]).to_not be_empty
      end

      example "my@username" do
        user.username = 'my@username'
        expect(user).to_not be_valid
        expect(user.errors[:username]).to_not be_empty
      end
    end
  end

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

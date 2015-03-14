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
#  default_role    :string
#  timezone        :string
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

RSpec.describe User, type: :model do
  context "attributes and validation" do
    let (:user) { User.new }

    before(:each) do
      user.save
    end

    it "requires a username" do
      expect(user.errors[:username]).to_not be_empty
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
        user.valid?
        expect(user.errors[:username]).to be_empty
      end

      example "moon_dogg_23" do
        user.username = 'moon_dogg_23'
        user.valid?
        expect(user.errors[:username]).to be_empty
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
        user.valid?
        expect(user.errors[:username]).to_not be_empty
      end
    end
  end
end

RSpec.describe User::AsSignUp, type: :model do
  context "after creation" do
    let(:user) {
      User::AsSignUp.new(
        username: 'test_user1',
        email: 'test_user1@example.com',
        password: 'testpass',
        password_confirmation: 'testpass',
        terms: '1'
      )
    }

    it "creates a signup confirmation" do
      expect(user.save).to be true
      expect(user.signup_confirmation).not_to be_nil
      expect(user.signup_confirmation.id).not_to be_nil
      expect(user.signup).to be_nil
    end

    it "creates a signup record when provided" do
      user.signup_data = {
        ip_address: '127.0.0.1',
        user_agent: 'test browser 1.0'
      }

      expect(user.save).to eq(true)
      expect(user.signup).not_to be_nil
    end

    it "automatically sets default_role to 'user'" do
      expect(user.default_role).to eq 'user'
    end
  end
end

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

RSpec.describe User::AsSignUp, type: :model do

  it "requires email" do
    user = User::AsSignUp.new(username: 'terry', :password => 'testpass')
    expect(user.valid?).to eq false
    expect(user.errors[:email]).to_not be_blank
  end

  context "has invalid usernames:" do
    let(:user) { User::AsSignUp.new }

    example "_myusername" do
      user.username = '_myusername'
      user.valid?
      expect(user.errors[:username]).to_not be_empty
    end

    example "my.username" do
      user.username = 'my.username'
      user.valid?
      expect(user.errors[:username]).to_not be_empty
    end

    example "my username" do
      user.username = 'my username'
      user.valid?
      expect(user.errors[:username]).to_not be_empty
    end

    example "my@username" do
      user.username = 'my@username'
      user.valid?
      expect(user.errors[:username]).to_not be_empty
    end

    example "5username" do
      user.username = '5username'
      user.valid?
      expect(user.errors[:username]).to_not be_empty
    end

    example "abc" do
      user.username = 'abc'
      user.valid?
      expect(user.errors[:username]).to_not be_empty
    end

    example "my-username" do
      user.username = 'my-username'
      user.valid?
      expect(user.errors[:username]).to_not be_empty
    end
  end
end

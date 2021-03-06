# == Schema Information
#
# Table name: signup_confirmations
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  token        :string           not null
#  confirmed_at :datetime
#

require 'rails_helper'

RSpec.describe SignupConfirmation, type: :model do
  fixtures :all

  describe "after create" do
    let(:user) { users(:appleseed) }
    let(:signup_confirmation) { user.create_signup_confirmation() }

    it "has a generated token" do
      expect(signup_confirmation.token).to_not be_nil
      expect(signup_confirmation.token).to_not eq ''
    end
  end
end

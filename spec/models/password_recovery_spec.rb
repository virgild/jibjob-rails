# == Schema Information
#
# Table name: password_recoveries
#
#  user_id    :integer          not null, primary key
#  token      :string           not null
#  created_at :datetime
#

require 'rails_helper'

RSpec.describe PasswordRecovery, type: :model do
  context "attributes" do
    let(:recovery) { PasswordRecovery.new }
    example "present" do
      expect(recovery.user_id).to be_nil
      expect(recovery.token).to be_blank
      expect(recovery.created_at).to be_blank
    end
  end
end

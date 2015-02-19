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

end

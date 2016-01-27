# == Schema Information
#
# Table name: signup_confirmations
#
#  id           :integer          not null, primary key
#  user_id      :integer
#  token        :string           not null
#  confirmed_at :datetime
#

class SignupConfirmationsController < ApplicationController

  def update
    @confirmation = SignupConfirmation.where(token: params[:t]).first

    if @confirmation && @confirmation.update(confirmed_at: Time.now)

    end
  end

end

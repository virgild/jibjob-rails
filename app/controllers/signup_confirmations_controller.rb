class SignupConfirmationsController < ApplicationController

  def update
    @confirmation = SignupConfirmation.where(token: params[:t]).first

    if @confirmation && @confirmation.update(confirmed_at: Time.now)

    end
  end

end

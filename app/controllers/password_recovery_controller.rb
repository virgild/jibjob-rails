class PasswordRecoveryController < ApplicationController

  def index

  end

  def create
    identifier = params[:username_or_email]

    if identifier.blank?
      @warning = "Enter the username or e-mail address you used to sign up."
    else
      PasswordRecoveryJob.perform_later(identifier)
    end

    render action: :index
  end

  def edit

  end

  def update
    token = params[:t]

    password = params[:password]
    password_confirmation = params[:password_confirmation]

    if password.blank? || password_confirmation.blank?
      return render action: :edit
    end

    if password != password_confirmation
      return render action: :edit
    end

    if token.blank?
      return render action: :edit
    end

    password_recovery = PasswordRecovery.find_by_token(token)
    if password_recovery.nil?
      return render action: :edit
    end

    user = password_recovery.user

    user.update!(password: password, password_confirmation: password_confirmation)

    flash['info'] = "Your password has been reset."
    redirect_to login_url
  end
end
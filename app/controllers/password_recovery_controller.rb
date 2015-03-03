class PasswordRecoveryController < ApplicationController
  force_ssl if: -> { Rails.env == 'production' }

  before_filter :check_valid_reset_token, only: [:edit, :update]

  def index

  end

  def create
    identifier = params[:username_or_email]

    if identifier.blank?
      @warning = "Enter the username or e-mail address you used to sign up."
    else
      flash.now["info"] = "The password reset instructions have been sent to the e-mail address you used to sign up."
      PasswordRecoveryJob.perform_later(identifier)
    end

    render action: :index
  end

  def edit

  end

  def update
    password = params[:password]
    password_confirmation = params[:password_confirmation]

    if password.blank? || password_confirmation.blank?
      @warning = "Enter the new password on both fields."
      return render action: :edit
    end

    if password != password_confirmation
      @warning = "The password confirmation must match."
      return render action: :edit
    end

    password_recovery = PasswordRecovery.find_by_token(@token)
    if password_recovery.nil?
      return redirect_to(reset_password_url)
    end

    user = password_recovery.user

    user.update!(password: password, password_confirmation: password_confirmation)
    password_recovery.destroy

    flash['info'] = "Your password has been reset."
    redirect_to login_url
  end

  private

  def check_valid_reset_token
    return redirect_to(reset_password_url) if params[:t].blank?

    @token = SecureMail.decrypt_wrapped_token(params[:t])

    if @token.blank? || (PasswordRecovery.where(token: @token).count == 0)
      return redirect_to(reset_password_url)
    end
  end
end
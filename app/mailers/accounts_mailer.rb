class AccountsMailer < ApplicationMailer
  def signup_confirmation(user)
    @user = user
    mail to: @user.email, subject: "Welcome to JibJob"
  end

  def password_reset(user)
    @user = user
    @secure_mail = SecureMail.new(@user)
    mail to: @user.email, subject: "JibJob - Password Reset"
  end
end
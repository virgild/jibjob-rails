class AccountsMailer < ApplicationMailer
  def signup_confirmation(user)
    @user = user
    mail to: @user.email, subject: "Welcome to JibJob"
  end
end

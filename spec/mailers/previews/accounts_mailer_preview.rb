# Preview all emails at http://localhost:3000/rails/mailers/accounts_mailer
class AccountsMailerPreview < ActionMailer::Preview
  def signup_confirmation
    user = User.last
    AccountsMailer.signup_confirmation(user)
  end

  def password_reset
    user = User.last
    AccountsMailer.password_reset(user)
  end
end
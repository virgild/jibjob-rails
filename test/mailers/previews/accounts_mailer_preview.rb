# Preview all emails at http://localhost:3000/rails/mailers/accounts_mailer
class AccountsMailerPreview < ActionMailer::Preview
  def signup_confirmation
    user = User.first
    Accounts.signup_confirmation(user)
  end
end

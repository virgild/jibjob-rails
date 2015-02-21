class PasswordRecoveryJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    identifier = args
    user = User.find_by_username(identifier) || User.find_by_email(identifier)

    if user
      user.password_recovery ||= user.create_password_recovery
      AccountsMailer.password_reset(user).deliver_later
    end
  end
end

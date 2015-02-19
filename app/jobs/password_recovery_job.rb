class PasswordRecoveryJob < ActiveJob::Base
  queue_as :default

  def perform(*args)
    identifier = args
    user = User.find_by_username(identifier) || User.find_by_email(identifier)

    if user
      if user.password_recovery.nil?
        rec = user.build_password_recovery
        rec.save
      end

      AccountsMailer.password_reset(user).deliver_later
    end
  end
end

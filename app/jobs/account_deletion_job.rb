class AccountDeletionJob < BaseJob
  queue_as :default

  def perform(*args)
    user = args[0]
    if user
      user.destroy!
    end
  end
end

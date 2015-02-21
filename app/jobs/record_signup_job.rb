class RecordSignupJob < ActiveJob::Base
  queue_as :logging

  def perform(*args)
    signup_params = args[0]

    user = User.find(signup_params['user_id'])

    signup_params['created_at'] = Time.at(signup_params['created_at'])

    if user
      user.create_signup(signup_params)
    end
  end
end

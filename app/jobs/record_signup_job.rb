class RecordSignupJob < ActiveJob::Base
  queue_as :logging

  def perform(*args)
    signup_params = args[0]

    user = User.find(signup_params['user_id'])

    signup_params['created_at'] = Time.at(signup_params['created_at'])

    if user
      signup = user.build_signup(signup_params)
      signup.save
    end
  end
end

module Auth
  class GoogleController < AccountsController
    def callback
      @user = User::AsGoogleSignUp.where(auth_uid: auth_hash.uid).first

      unless @user
        @user = User::AsGoogleSignUp.new_from_auth_hash(auth_hash)
        @user.signup_data.merge!({
          :ip_address => request.remote_ip,
          :user_agent => request.env["HTTP_USER_AGENT"],
          :extras => { env: Rails.env },
          :created_at => Time.now
        })
        @user.save!
      end

      session['auth.default.user'] = @user.id
      redirect_to user_resumes_path(@user)
    end
  end
end
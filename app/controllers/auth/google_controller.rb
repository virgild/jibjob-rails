module Auth
  class GoogleController < AccountsController
    def callback
      @user = User::AsGoogleSignUp.where(auth_uid: auth_hash.uid).first

      unless @user
        @user = User::AsGoogleSignUp.new_from_auth_hash(auth_hash)
        @user.save!
      end

      session['auth.default.user'] = @user.id
      redirect_to user_resumes_path(@user)
    end
  end
end
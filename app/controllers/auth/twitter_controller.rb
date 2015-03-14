module Auth
  class TwitterController < AccountsController
    def callback
      @user = User::AsTwitterSignUp.where(auth_uid: auth_hash.uid).first

      unless @user
        @user = User::AsTwitterSignUp.new_from_auth_hash(auth_hash)
        @user.save!
      end

      session['auth.default.user'] = @user.id
      redirect_to user_resumes_path(@user)
    end
  end
end
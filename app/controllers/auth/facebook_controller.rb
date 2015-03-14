module Auth
  class FacebookController < AccountsController
    protect_from_forgery except: :deleted

    def callback
      @user = User::AsFacebookSignUp.where(auth_uid: auth_hash.uid).first

      unless @user
        @user = User::AsFacebookSignUp.new_from_auth_hash(auth_hash)
        @user.save!
      end

      session['auth.default.user'] = @user.id
      redirect_to user_resumes_path(@user)
    end

    # Callback that Facebook calls when the user removes the app in Facebook
    def deleted
      @user = User::AsFacebookSignUp.where(auth_uid: auth_hash.uid).first
      if @user
        AccountDeletionJob.perform_later(@user)
      end
    end
  end
end
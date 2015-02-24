class SessionsController < ApplicationController
  force_ssl only: :new, if: -> { Rails.env == 'production' }

  def new
    if current_user
      redirect_to user_url(current_user)
    end
  end

  def create
    if params[:username].blank? || params[:password].blank?
      flash.now['warning'] = "Invalid account details"
      return render action: :new
    end

    user = User::AsSignUp.find_by_username(params[:username])
    if user.nil?
      flash.now['warning'] = "Invalid account details"
      return render action: :new
    end

    if user.authenticate(params[:password])
      session['auth.default.user'] = user.id

      if user.default_role == 'admin'
        redirect_to admin_root_url
      else
        redirect_to user_resumes_url(user)
      end
    else
      flash.now['warning'] = "Invalid account details"
      render action: :new
    end
  end

  def destroy
    reset_session
  end

  def logout
    destroy

    redirect_to login_url
  end
end

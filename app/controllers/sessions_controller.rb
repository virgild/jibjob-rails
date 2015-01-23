class SessionsController < ApplicationController
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

    user = User.find_by_username(params[:username])
    if user.nil?
      flash.now['warning'] = "Invalid account details"
      return render action: :new
    end

    if user.authenticate(params[:password])
      session['auth.default.user'] = user.id
      flash.now['info'] = "You have successfully logged in."
      redirect_to user_resumes_url(user)
    else
      flash.now['warning'] = "Invalid account details"
      render action: :new
    end
  end

  def destroy
    session.clear
  end

  def logout
    if current_user
      destroy
      flash['info'] = "You have successfully logged out."
    end

    redirect_to new_session_url
  end
end

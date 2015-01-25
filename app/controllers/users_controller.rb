class UsersController < ApplicationController
  before_filter :require_current_user, except: [:new, :create]

  def new
    if current_user
      redirect_to user_url(current_user)
    end

    @user = User::AsSignUp.new
  end

  def create
    @user = User::AsSignUp.new(user_params)

    @user.signup_data.merge!({
      :ip_address => request.remote_ip,
      :user_agent => request.env["HTTP_USER_AGENT"],
      :extras => { env: Rails.env },
      :created_at => Time.now
    })

    if @user.save
      session['auth.default.user'] = @user.id
      redirect_to user_resumes_url(@user), notice: "Thank you for signing up."
    else
      flash.now[:danger] = "There are issues with the sign up form entries."
      render action: :new
    end
  end

  def show
    @user = User.find_by_username(params[:id])

    respond_to do |format|
      format.html
      format.json { render json: @user, root: nil }
    end
  end

  def edit

  end

  def update

  end

  private

  def user_params
    params.require(:user).permit(:username, :email, :password, :password_confirmation, :terms)
  end

end

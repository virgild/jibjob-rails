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

    if @user.valid? && @user.save
      redirect_to user_url(@user), notice: "Thank you for signing up."
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

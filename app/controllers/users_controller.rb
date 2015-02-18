class UsersController < ApplicationController
  before_filter :require_current_user, except: [:new, :create]

  force_ssl only: :new, if: -> { Rails.env == 'production' }

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
      render action: :new
    end
  end

  def show
    load_user

    respond_to do |format|
      format.html
      format.json { render json: @user, root: nil }
    end
  end

  def edit

  end

  def update
    load_user
    build_user

    if @user.save
      respond_to do |format|
        format.html {
          flash['success'] = "Updated."
          redirect_to user_url(@user)
        }
      end
    else
      respond_to do |format|
        format.html {
          flash.now['warning'] = "There are errors in the form."
          render action: :show
        }
      end
    end
  end

  private

  def load_user
    @user ||= User.find_by_username(params[:username])
  end

  def build_user
    @user.attributes = user_params
  end

  def user_params
    user_params = params[:user]
    user_params ? user_params.permit(:username, :email, :password, :password_confirmation, :timezone, :terms) : {}
  end

end

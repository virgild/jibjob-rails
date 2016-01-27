# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  email           :string
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  timezone        :string
#  default_role    :string
#  auth_provider   :string
#  auth_uid        :string
#  auth_name       :string
#  auth_token      :string
#  auth_secret     :string
#  auth_expires    :datetime
#
# Indexes
#
#  index_users_on_auth_provider               (auth_provider)
#  index_users_on_auth_provider_and_auth_uid  (auth_provider,auth_uid)
#  index_users_on_email                       (email)
#  index_users_on_username                    (username)
#

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

  def delete

  end

  def destroy
    AccountDeletionJob.perform_later(current_user)

    redirect_to action: :delete, processing: true
  end

  private

  def user_scope
    User.with_owner(params[:id])
  end

  def load_user
    @user ||= user_scope.first
    if @user.id != current_user.id
      error401
    end
  end

  def build_user
    @user.attributes = user_params
  end

  def user_params
    user_params = params[:user]
    user_params ? user_params.permit(:username, :email, :password, :password_confirmation, :timezone, :terms) : {}
  end
end

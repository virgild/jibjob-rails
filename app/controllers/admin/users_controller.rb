class Admin::UsersController < Admin::ApplicationController

  def index
    load_users
  end

  def show
    load_user
  end

  private

  def load_user
    @user ||= users_scope.find(params[:id])
  end

  def load_users
    @users ||= users_scope.all.order(:created_at).reverse_order
  end

  def users_scope
    User.all
  end
end
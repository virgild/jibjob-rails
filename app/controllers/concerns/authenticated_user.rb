module AuthenticatedUser
  extend ActiveSupport::Concern

  def current_user
    if session["auth.default.user"]
      @current_user ||= User.find_by_id(session["auth.default.user"])
    else
      @current_user = nil
    end
  end

  def require_current_user
    if current_user.nil?
      redirect_to login_url
    end
  end

  def require_admin_role
    if current_user && !current_user.is_admin?
      error401
    elsif current_user.nil?
      redirect_to login_url
    end
  end
end
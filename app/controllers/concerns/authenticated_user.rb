module AuthenticatedUser
  extend ActiveSupport::Concern

  def current_user
    if session["auth.default.user"]
      @current_user ||= User.find(session["auth.default.user"])
    else
      @current_user = nil
    end
  end

  def require_current_user
    if current_user.nil?
      redirect_to new_session_url
    end
  end
end
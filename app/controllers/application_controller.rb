class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include AuthenticatedUser
  include GeokitOverrides
  include ActivityLogger

  records_actions

  rescue_from ::Errors::Unauthorized, with: :go_unauthorized

  def error404
    raise ActionController::RoutingError.new('Not Found')
  end

  def error401
    raise ::Errors::Unauthorized.new("Unauthorized resource")
  end

  protected

  def go_unauthorized
    if current_user
      flash[:warning] = "You have no access to the requested resource."
      redirect_to user_url(current_user)
    else
      redirect_to login_url
    end
  end
end

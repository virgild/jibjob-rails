class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  include AuthenticatedUser
  include GeokitOverrides

  def error404
    raise ActionController::RoutingError.new('Not Found')
  end
end

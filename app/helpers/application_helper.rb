module ApplicationHelper
  include AuthenticatedUser

  def facebook_auth_path
    "/app/auth/facebook"
  end

  def twitter_auth_path
    "/app/auth/twitter"
  end

  def google_auth_path
    "/app/auth/google"
  end
end

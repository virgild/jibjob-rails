module ApplicationHelper
  include AuthenticatedUser

  def page_body
    body_opts = {
      'class' => []
    }

    if current_user
      body_opts['class'] << 'user'
      body_opts['data-user-id'] = current_user.id
    end

    content_tag(:body, body_opts) do
      yield
    end
  end

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

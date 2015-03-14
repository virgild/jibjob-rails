module Auth
  class AccountsController < ApplicationController
    def failure
      flash[:info] = "Login was not authorized"
      redirect_to signup_url
    end

    protected

    def auth_hash
      request.env['omniauth.auth']
    end
  end
end
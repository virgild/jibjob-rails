module Auth
  class AccountsController < ApplicationController
    def failure
      flash[:info] = "Login with #{params[:strategy].titleize} not authorized"
      redirect_to params[:origin] if params[:origin]
    end

    protected

    def auth_hash
      request.env['omniauth.auth']
    end
  end
end
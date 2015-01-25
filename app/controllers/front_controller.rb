class FrontController < ApplicationController

  def index

  end

  def features
    set_wallaby_pass
  end

  def about

  end

  def team

  end

  def terms_of_service

  end

  def privacy_policy

  end

  def pricing

  end

  def wallaby
    render layout: false
  end

end

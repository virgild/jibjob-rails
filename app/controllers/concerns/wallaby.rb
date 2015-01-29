module Wallaby
  extend ActiveSupport::Concern

  included do
    before_filter :set_wallaby_pass
    before_filter :check_wallaby_pass, except: :wallaby
  end

  private

  def set_wallaby_pass
    if params[:_wallaby]
      cookies.signed[:wallaby] ||= {
        value: 'pass',
        expires: 1.year.from_now
      }
    end
  end

  def check_wallaby_pass
    if cookies.signed[:wallaby] != 'pass'
      session.clear
      redirect_to "/wallaby"
    end
  end
end
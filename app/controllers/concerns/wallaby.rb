module Wallaby
  extend ActiveSupport::Concern

  included do
    before_filter :check_wallaby_pass, except: [:wallaby, :features]
  end

  private

  def set_wallaby_pass
    cookies[:wallaby] ||= {
      value: 'pass',
      expires: 1.day.from_now
    }
  end

  def check_wallaby_pass
    if cookies[:wallaby] != 'pass'
      redirect_to wallaby_url
    end
  end
end
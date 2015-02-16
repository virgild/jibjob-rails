module HasUserResume
  extend ActiveSupport::Concern

  included do
    before_filter :require_current_user
  end
end
class Admin::ApplicationController < ApplicationController
  before_filter :require_current_user
  before_filter :require_admin_role
end
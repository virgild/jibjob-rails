module ActivityLogger
  extend ActiveSupport::Concern

  included do
    extend ClassMethods
  end

  def record_activity(opts={})
    if current_user
      RecordActivityLogJob.perform_later(
        current_user,
        "#{controller_name}.#{action_name}",
        request.path,
        request.remote_ip,
        request.user_agent,
        Time.now.to_i
      )
    end
  end

  module ClassMethods
    def records_actions
      after_filter :record_activity
    end
  end
end
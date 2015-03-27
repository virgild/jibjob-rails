class RecordActivityLogJob < BaseJob
  queue_as :logging

  def perform(user, event, url, ip_address, user_agent_string, timestamp, metadata={})
    user_agent = UserAgent.do_record(user_agent_string)

    user.activity_logs.create(
      event: event,
      url: url,
      ip_address: ip_address,
      user_agent_id: user_agent.id,
      metadata: metadata,
      created_at: Time.at(timestamp)
    )
  end
end

class PageViewRecorderJob < BaseJob
  queue_as :logging

  def perform(resume_id, ip_addr, url, referrer, user_agent, t=DateTime.now)
    resume = Resume.find_by_id(resume_id)

    if resume
      # Save the publication view
      pubview = PublicationView.new(
        resume_id: resume_id,
        ip_addr: ip_addr,
        referrer: referrer,
        user_agent: user_agent,
        url: url,
        created_at: t
      )
      pubview.save
    end
  end
end

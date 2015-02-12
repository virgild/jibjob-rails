class PublicationsController < ApplicationController

  layout 'publication'

  def show
    @resume = Resume.where(slug: params[:slug], is_published: true).first
    @resume_data = PublicationSerializer.new(@resume)

    # Log page view
    record_pageview
  end

  def not_found

  end

  private

  def record_pageview
    PageViewRecorderJob.perform_later(@resume.id,
      request.ip,
      request.url,
      request.referrer,
      request.user_agent
    )
  end
end

class PublicationsController < ApplicationController

  layout 'publication'

  def show
    @resume = Resume.where(slug: params[:slug], is_published: true).first
    @resume_data = PublicationSerializer.new(@resume)

    # Log page view
    record_pageview

    respond_to do |format|
      format.html { }
      format.json { render json: @resume.generate_json_text }
      format.text { render text: @resume.generate_plain_text }
      format.pdf { redirect_to @resume.pdf.url }
      format.zip { }
    end
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

class PublicationsController < ApplicationController

  layout 'publication'

  before_filter :load_resume, only: [:show]

  def show
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

  def load_resume
    @resume = Resume.published.where(slug: params[:slug]).last

    if @resume.nil?
      render action: :not_found, status: :not_found
    end
  end

  def record_pageview
    PageViewRecorderJob.perform_later(@resume.id,
      request.ip,
      request.url,
      request.referrer,
      request.user_agent
    )
  end
end

class PublicationsController < ApplicationController
  layout 'publication'

  before_filter :load_resume
  before_filter :check_access_code, only: [:show]

  def show
    @resume_data = Resume::PublicationSerializer.new(@resume).to_json
    @title_name_frag = @resume.data.full_name.present? ? @resume.data.full_name : "JibJob Resume"

    # Log page view
    record_pageview

    respond_to do |format|
      format.html { }
      format.json { render json: @resume.generate_json_text }
      format.text { render text: @resume.generate_plain_text }
      format.pdf { redirect_to @resume.pdf.url }
    end
  end

  def access_code
  end

  def post_access_code
    if @resume.access_code == params[:access_code]
      session[:resume_access_codes] ||= {}
      session[:resume_access_codes][@resume.slug] = @resume.access_code
      redirect_to publication_url(slug: @resume.slug)
    else
      @msg = "Incorrect access code"
      render action: :access_code
    end
  end

  private

  def resumes_scope
    Resume.published
  end

  def load_resume
    @resume = resumes_scope.where(slug: params[:slug]).last or error404
  end

  def check_access_code
    if @resume.requires_access_code? && !request_has_resume_access_code_for(@resume)
      redirect_to action: :access_code
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

  def request_has_resume_access_code_for(resume)
    session[:resume_access_codes] && (session[:resume_access_codes][resume.slug] == resume.access_code)
  end
end

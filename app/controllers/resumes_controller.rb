class ResumesController < ApplicationController
  protect_from_forgery except: [:publish, :unpublish, :create, :update]

  before_filter :require_current_user
  before_filter :require_resume_access
  before_filter :load_resume, only: [:show, :edit, :update, :delete, :destroy, :publish, :unpublish]
  before_filter :set_editor_mode, only: [:new, :edit, :create, :update]

  include HasUserResume

  def index
    @resumes_data = current_user.cached_resume_list do
      resume_scope.list.map { |resume|
        Rails.cache.fetch(resume, updated_at: resume.updated_at, views: resume.cached_total_page_views) do
          Resume::LightSerializer.new(resume)
        end
      }.to_json
    end
  end

  def new
    unless current_user.has_available_resume_slot?
      redirect_to user_resumes_url(current_user)
    end

    build_resume
    @resume_data = ResumeSerializer.new(@resume).to_json
  end

  def create
    build_resume

    if @resume.save
      code = :ok
      @meta = { redirect: user_resume_url(current_user, @resume) }
    else
      code = :conflict
    end

    respond_to do |format|
      format.json { render json: @resume, status: code, meta: @meta, root: 'resume' }
    end
  end

  def show
    respond_to do |format|
      format.html do
        @user_resume = ResumeSerializer.new(@resume).to_json
      end
      format.text { render plain: @resume.generate_plain_text }
      format.json { render json: @resume.generate_json_text }
      format.pdf {
        render pdf: @resume.id.to_s,
          show_as_html: params[:debug].present?,
          disable_external_links: true,
          disable_internal_links: true,
          print_media_type: false,
          outline: { outline: true }
      }
      format.xml { render layout: false }
    end
  end

  def edit
    build_resume
    @resume_data = Resume::EditorSerializer.new(@resume).to_json
  end

  def update
    build_resume

    if @resume.save
      code = :ok
      @meta = {}
    else
      code = :conflict
    end

    respond_to do |format|
      format.json { render json: @resume, status: code, meta: @meta, root: 'resume' }
    end
  end

  def delete

  end

  def destroy
    @resume.destroy
    redirect_to user_resumes_url(current_user)
  end

  private

  def load_resumes
    # TODO: Slow when things grow
    @resumes ||= resume_scope.list
  end

  def resume_scope
    current_user.resumes.order(:id)
  end

  def load_resume
    @resume ||= resume_scope.find(params[:id])
  end

  def build_resume
    @resume ||= resume_scope.build
    @resume.attributes = resume_params
  end

  def resume_params
    resume_params = params[:resume]

    # Normalize 'content' text
    if resume_params && resume_params[:content]
      resume_params[:content].gsub!(/\r\n/, "\n")
    end

    resume_params ? resume_params.permit(:name, :content, :slug, :is_published, :access_code) : {}
  end

  def require_resume_access
    if params[:user_id].to_i != current_user.id
      error401
    end
  end

  def set_editor_mode
    browser = Browser.new(ua: request.user_agent)
    if browser.mobile?
      @use_plain_editor = true
    end

    @use_plain_editor = always_use_plain_editor_for_now = true
  end

  def list_cache_identifier
    if resume_scope.recently_updated.count > 0
      "resumes-#{resume_scope.count}-#{current_user.resumes.recently_updated.first.updated_at.to_i}"
    else
      "resumes-0-0"
    end
  end

  def list_cache_key
    total_resume_views = current_user.cached_total_resume_views
    @_list_cache_key ||= "user-#{current_user.id}-#{list_cache_identifier}-#{total_resume_views}"
  end
end

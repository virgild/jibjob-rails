class ResumesController < ApplicationController
  protect_from_forgery except: [:publish, :unpublish, :create, :update]

  before_filter :require_current_user
  before_filter :load_resume, only: [:show, :edit, :update, :delete, :destroy, :publish, :unpublish]
  before_filter :set_editor_mode, only: [:new, :edit, :create, :update]

  include HasUserResume

  def index
    load_resumes
    cache_key = "user-#{current_user.id}-resumes-list-#{@resumes.first.nil? ? 0 : @resumes.first.updated_at.to_i}"
    @resumes_data = Rails.cache.fetch(cache_key) do
      ActiveModel::ArraySerializer.new(@resumes).to_json
    end
  end

  def new
    build_resume
    @resume_data = ResumeSerializer.new(@resume)
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
        @user_resume = ResumeSerializer.new(@resume)
        @resume_data = PublicationSerializer.new(@resume)
      end
      format.text { render plain: @resume.generate_plain_text }
      format.json { render json: @resume.generate_json_text }
    end
  end

  def edit
    build_resume
    @resume_data = ResumeSerializer.new(@resume)
  end

  def update
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

  def delete

  end

  def destroy
    @resume.destroy
    redirect_to user_resumes_url(current_user)
  end

  private

  def load_resumes
    # TODO: Slow when things grow
    @resumes ||= resume_scope
  end

  def resume_scope
    current_user.resumes
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

  def set_editor_mode
    browser = Browser.new(ua: request.user_agent)
    if browser.mobile?
      @use_plain_editor = true
    end

    @use_plain_editor = always_use_plain_editor_for_now = true
  end
end

class ResumesController < ApplicationController
  protect_from_forgery except: [:publish, :unpublish, :create, :update]
  before_filter :load_resume, only: [:show, :edit, :update, :delete, :destroy, :publish, :unpublish]

  include HasUserResume

  def index
    @item_limit = 5
    load_resumes
  end

  def new
    build_resume
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
        @resume_data = @resume.resume_data
      end
      format.text { render plain: @resume.generate_plain_text }
      format.json { render json: @resume.generate_json_text }
    end
  end

  def edit
    build_resume
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

  def publish
    @resume.is_published = true

    if @resume.save
      @result = "ok"
      @status = :ok
    else
      @result = "error"
      @status = :conflict
    end

    respond_to do |format|
      format.json { render json: { result: @result, resume: { slug: @resume.slug, errors: @resume.errors } }, status: @status }
    end
  end

  def unpublish
    @resume.is_published = false

    if @resume.save
      @result = "ok"
    else
      @result = "error"
    end

    respond_to do |format|
      format.json { render json: { result: @result, resume: { slug: @resume.slug } } }
    end
  end

  private

  def load_resumes
    # TODO: Slow when things grow
    @resumes ||= resume_scope.order(:updated_at).reverse_order.limit(@item_limit)
  end
end

class ResumesController < ApplicationController
  protect_from_forgery except: [:publish, :unpublish]
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
      redirect_to user_resume_url(current_user, @resume)
    else
      flash.now[:danger] = "There are errors in your form entry."
      render action: :new
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
      flash.now[:success] = "Resume \"#{@resume.name}\" updated."
      redirect_to user_resume_url(current_user, @resume)
    else
      flash.now[:warning] = "There are errors in the form."
      render action: :edit
    end
  end

  def delete

  end

  def destroy
    @resume.destroy
    redirect_to user_resumes_url(current_user)
  end

  def publish
    @resume.slug = params[:resume][:slug]
    @resume.is_published = true

    if @resume.save
      @result = "ok"
    else
      @result = "error"
    end

    respond_to do |format|
      format.json { render json: { result: @result } }
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
      format.json { render json: { result: @result } }
    end
  end

  private

  def load_resumes
    # TODO: Slow when things grow
    @resumes ||= resume_scope.order(:updated_at).reverse_order.limit(@item_limit)
  end
end

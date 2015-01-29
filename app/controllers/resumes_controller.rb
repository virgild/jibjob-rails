class ResumesController < ApplicationController
  before_filter :require_current_user
  before_filter :load_resume, only: [:show, :edit, :update, :destroy]

  def index
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
    load_resume
  end

  def destroy
    @resume.destroy
    redirect_to user_resumes_url(current_user)
  end

  private

  def resume_scope
    current_user.resumes
  end

  def load_resumes
    # TODO: Slow when things grow
    @resumes ||= resume_scope.order(:created_at).all
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

    resume_params ? resume_params.permit(:name, :content) : {}
  end
end

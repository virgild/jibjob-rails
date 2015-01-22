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

  def destroy
    @resume.destroy
    redirect_to user_resumes_url(current_user)
  end

  private

  def resume_scope
    current_user.resumes
  end

  def load_resumes
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
    resume_params ? resume_params.permit(:name, :slug, :content) : {}
  end
end

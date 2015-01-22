class ResumesController < ApplicationController
  before_filter :require_current_user

  def index
    @resumes = resumes.all
  end

  def new
    @resume = resumes.build
  end

  def create
    @resume = resumes.build(resume_params)

    if @resume.valid? && @resume.save
      redirect_to user_resume_url(current_user, @resume)
    else
      flash.now[:danger] = "There are errors in your form entry."
      render action: :new
    end
  end

  def show
    @resume = resumes.find(params[:id])
  end

  def edit
    @resume = resumes.find(params[:id])
  end

  def update

  end

  def destroy

  end

  private

  def resumes
    current_user.resumes
  end

  def resume_params
    params.require(:resume).permit(:name, :slug, :content)
  end
end

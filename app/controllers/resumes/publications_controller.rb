class Resumes::PublicationsController < ApplicationController
  before_filter :require_current_user

  def index
    load_publications
  end

  def new
    build_publication
  end

  def create
    build_publication

    if @publication.save
      redirect_to user_resume_url(current_user, @resume)
    else
      flash.now['warning'] = "There are errors in the form."
      render action: :new
    end
  end

  private

  def load_publications
    @publications ||= load_resume.publications
  end

  def build_publication
    @publication ||= load_resume.publications.build(publication_params.merge(user: current_user))
  end

  def resume_scope
    current_user.resumes
  end

  def load_resume
    @resume ||= resume_scope.find(params[:resume_id])
  end

  def publication_params
    publication_params = params[:publication]
    publication_params ? publication_params.permit(:slug, :publish_date) : {}
  end

end
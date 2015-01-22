class ResumesController < ApplicationController
  before_filter :require_current_user

  def index
    @resumes = resumes.all
  end

  def new

  end

  def create

  end

  def show

  end

  def edit

  end

  def update

  end

  def destroy

  end

  private

  def resumes
    current_user.resumes
  end
end

class ResumeStatsController < ApplicationController
  include HasUserResume

  before_filter :load_resume

  def index
    @resume_data = ResumeStatsSerializer.new(@resume)
  end

  private

  def resume_scope
    current_user.resumes
  end

  def load_resume
    @resume ||= resume_scope.find(params[:id])
  end

end

class ResumeStatsController < ApplicationController
  include HasUserResume

  before_filter :load_resume

  def index
    lastview = @resume.publication_views.first
    cache_key = "user-#{current_user.id}-resume-#{@resume.id}-stats-#{lastview.created_at}"
    @resume_data = Rails.cache.fetch(cache_key) do
      ResumeStatsSerializer.new(@resume).to_json
    end
  end

  private

  def resume_scope
    current_user.resumes
  end

  def load_resume
    @resume ||= resume_scope.find(params[:id])
  end

end

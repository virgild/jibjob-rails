class ResumeStatsController < ApplicationController
  include HasUserResume

  before_filter :load_resume

  def index
    @resume_data = ResumeSerializer.new(@resume).to_json
    @views = @resume.publication_views.in_range(Time.now, 2.months.ago).paginate(per_page: 10, page: 1)
    @views_data = ActiveModel::ArraySerializer.new(@views).to_json
    @resume_stats = @resume.hourly_stats_for(5.days.ago.in_time_zone(@resume.user.timezone).at_beginning_of_day, Time.now.in_time_zone(@resume.user.timezone).at_end_of_day).to_json
  end

  private

  def resume_scope
    current_user.resumes
  end

  def load_resume
    @resume ||= resume_scope.find(params[:id]) || error404
  end

end

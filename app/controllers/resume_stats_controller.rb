class ResumeStatsController < ApplicationController
  include HasUserResume

  before_filter :load_resume

  def index
    @resume_data = ResumeSerializer.new(@resume).to_json
    @views = @resume.publication_views.in_range(Time.now, 2.months.ago).paginate(per_page: 10, page: 1)
    @views_data = ActiveModel::ArraySerializer.new(@views).to_json

    start_time = 5.days.ago.in_time_zone(@resume.user.timezone).at_beginning_of_day
    end_time = Time.now.in_time_zone(@resume.user.timezone).at_end_of_day
    @resume_stats = @resume.hourly_stats_for(start_time, end_time).to_json
  end

  def hour_views
    date = Date.new(params[:year].to_i, params[:month].to_i, params[:day].to_i).in_time_zone(current_user.timezone)
    start_time = date + params[:hour].to_i.hours
    end_time = start_time.at_end_of_hour

    @views = @resume.publication_views.in_range(end_time, start_time)
    @views_data = ActiveModel::ArraySerializer.new(@views).to_json

    respond_to do |format|
      format.json { render json: @views_data }
    end
  end

  private

  def resume_scope
    current_user.resumes
  end

  def load_resume
    @resume ||= resume_scope.find(params[:id]) || error404
  end

end

class PublicationsController < ApplicationController

  layout 'publication'

  def index

  end

  def show
    @resume = Resume.find_by_slug(params[:id])

    if @resume.nil?
      return render action: :not_found, status: :not_found
    end

    @resume_data = @resume.resume_data
  end

  def not_found

  end
end

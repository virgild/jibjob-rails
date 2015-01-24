class PublicationsController < ApplicationController

  layout 'publication'

  def show
    @publication = Publication.find_by_slug(params[:slug])
    if @publication.nil?
      return render action: :not_found, status: :not_found
    end

    @resume = @publication.resume
    if @resume.nil?
      return render action: :not_found, status: :not_found
    end

    @resume_data = @resume.resume_data
  end

  def not_found

  end
end

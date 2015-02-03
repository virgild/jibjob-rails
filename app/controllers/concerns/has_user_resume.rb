module HasUserResume
  extend ActiveSupport::Concern

  included do
    before_filter :require_current_user
  end

  def resume_scope
    current_user.resumes
  end

  def load_resume
    @resume ||= resume_scope.find(params[:id])
  end

  def build_resume
    @resume ||= resume_scope.build
    @resume.attributes = resume_params
    @resume_data = serialize_model(@resume)
  end

  def resume_params
    resume_params = params[:resume]

    # Normalize 'content' text
    if resume_params && resume_params[:content]
      resume_params[:content].gsub!(/\r\n/, "\n")
    end

    resume_params ? resume_params.permit(:name, :content, :slug, :is_published) : {}
  end
end
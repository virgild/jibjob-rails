class ResumeSerializer < BaseSerializer
  attributes :id, :name, :content, :slug, :guid, :status,
    :created_at, :updated_at, :edition, :descriptor,
    :is_published, :user_id

  attributes :username, :errors

  attributes :show_page, :edit_page, :delete_page, :destroy_page
  attributes :user_pdf_file, :user_plaintext_file, :user_json_file

  # has_one :user

  self.root = false

  def username
    object.user.username
  end

  def user_pdf_file
    return nil if object.new_record?
    if object.pdf
      object.pdf.url
    end
  end

  def user_plaintext_file
    return nil if object.new_record?
    user_resume_path(object.user, object, format: :txt)
  end

  def user_json_file
    return nil if object.new_record?
    user_resume_path(object.user, object, format: :json)
  end

  def errors
    object.errors.to_a
  end

  def show_page
    return nil if object.new_record?
    user_resume_path(object.user, object)
  end

  def edit_page
    return nil if object.new_record?
    edit_user_resume_path(object.user, object)
  end

  def delete_page
    return nil if object.new_record?
    delete_user_resume_path(object.user, object)
  end

  def destroy_page
    return nil if object.new_record?
    user_resume_path(object.user, object)
  end
end

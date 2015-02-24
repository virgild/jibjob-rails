class ResumeSerializer < BaseSerializer
  attributes :id, :name, :content, :slug, :guid, :status,
    :created_at, :updated_at, :edition, :descriptor,
    :is_published, :user_id

  attributes :username, :errors

  attributes :show_page, :edit_page, :delete_page, :destroy_page, :stats_page
  attributes :user_pdf_file, :user_plaintext_file, :user_json_file
  attributes :structure, :pageview_count, :new_record, :publish_url
  attributes :total_page_views, :access_code

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

  def stats_page
    return nil if object.new_record?
    stats_user_resume_path(object.user, object)
  end

  def pageview_count
    return nil if object.new_record?
    object.publication_views.count
  end

  def publish_url
    return nil if object.new_record?
    publication_path(object.slug)
  end

  def new_record
    object.new_record?
  end
end

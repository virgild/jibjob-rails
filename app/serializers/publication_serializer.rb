class PublicationSerializer < ResumeSerializer
  attributes :id

  def id
    object.guid
  end

  def filter(keys)
    keys - [
      :errors,
      :created_at,
      :updated_at,
      :edition,
      :is_published,
      :name,
      :show_page,
      :delete_page,
      :destroy_page,
      :edit_page,
      :slug,
      :guid,
      :status,
      :user_id,
      :user_json_file,
      :user_pdf_file,
      :user_plaintext_file,
      :username,
      :content,
      :descriptor,
    ]
  end

end
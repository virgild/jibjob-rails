class PublicationSerializer < ResumeSerializer
  attributes :id
  attributes :pdf_file_url, :plaintext_file_url, :json_url, :package_url

  def pdf_file_url
    resource_url_for_format(:pdf)
  end

  def plaintext_file_url
    resource_url_for_format(:txt)
  end

  def json_url
    resource_url_for_format(:json)
  end

  def package_url
    resource_url_for_format(:zip)
  end

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
      :stats_page,
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
      :pageview_count
    ]
  end

  private

  def resource_url_for_format(format = :html)
    publication_path(object, slug: object.slug, format: format)
  end

end
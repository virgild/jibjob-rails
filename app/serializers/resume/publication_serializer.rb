class Resume::PublicationSerializer < ResumeSerializer
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
    [
      :id,
      :json_url,
      :package_url,
      :pdf_file_url,
      :plaintext_file_url,
      :structure
    ]
  end

  private

  def resource_url_for_format(format = :html)
    publication_path(object, slug: object.slug, format: format)
  end

end
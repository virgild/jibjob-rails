class ResumeSerializer < ActiveModel::Serializer
  attributes :id, :name, :content, :slug, :guid, :status,
    :created_at, :updated_at, :edition,
    :is_published, :user_id

  attributes :username, :errors, :user_pdf_file

  # has_one :user

  self.root = false

  def username
    object.user.username
  end

  def user_pdf_file
    if object.pdf
      object.pdf.url
    end
  end

  def errors
    object.errors.to_a
  end
end

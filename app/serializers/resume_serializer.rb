# == Schema Information
#
# Table name: resumes
#
#  id                      :integer          not null, primary key
#  user_id                 :integer          not null
#  name                    :string           not null
#  content                 :text             not null
#  guid                    :string           not null
#  status                  :integer          default(0), not null
#  created_at              :datetime         not null
#  updated_at              :datetime         not null
#  pdf_file_name           :string
#  pdf_content_type        :string
#  pdf_file_size           :integer
#  pdf_updated_at          :datetime
#  edition                 :integer          default(0), not null
#  slug                    :string           not null
#  is_published            :boolean          default(FALSE), not null
#  access_code             :string
#  pdf_edition             :integer          default(0), not null
#  pdf_pages               :integer
#  publication_views_count :integer          default(0), not null
#  theme                   :string
#
# Indexes
#
#  index_resumes_on_slug  (slug) UNIQUE
#

class ResumeSerializer < BaseSerializer
  attributes :id,
    :name,
    :slug,
    :created_at,
    :updated_at,
    :is_published,
    :show_page,
    :edit_page,
    :delete_page,
    :destroy_page,
    :stats_page,
    :user_pdf_file,
    :user_plaintext_file,
    :user_json_file,
    :pageview_count,
    :new_record,
    :publish_url,
    :total_page_views,
    :access_code,
    :thumbnail,
    :recently_new,
    :content,
    :structure,
    :errors,
    :pdf_page_count,
    :current_theme,
    :theme

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

  def thumbnail
    return nil if object.new_record?
    if object.pdf
      object.pdf.url(:thumb)
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
    object.total_page_views
  end

  def publish_url
    return nil if (object.new_record? || object.slug.blank?)
    publication_path(object.slug)
  end

  def new_record
    object.new_record?
  end

  def created_at
    unless object.new_record?
      object.created_at.in_time_zone(object.user.timezone).strftime("%b. %d, %Y %l:%M %p")
    end
  end

  def updated_at
    unless object.new_record?
      object.updated_at.in_time_zone(object.user.timezone).strftime("%b. %d, %Y %l:%M %p")
    end
  end

  def recently_new
    object.recently_new?
  end

  def pdf_page_count
    object.pdf_pages
  end
end

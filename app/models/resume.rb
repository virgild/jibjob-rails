# == Schema Information
#
# Table name: resumes
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  name             :string           not null
#  content          :text             not null
#  guid             :string           not null
#  status           :integer          default("0"), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  pdf_file_name    :string
#  pdf_content_type :string
#  pdf_file_size    :integer
#  pdf_updated_at   :datetime
#  edition          :integer          default("1")
#  slug             :string           not null
#  is_published     :boolean          default("false"), not null
#
# Indexes
#
#  index_resumes_on_slug  (slug) UNIQUE
#

class Resume < ActiveRecord::Base
  validates :user, presence: true
  validates :name, presence: true
  validates :guid, presence: true, uniqueness: true
  validates :status, presence: true, numericality: true
  validates :edition, presence: true, numericality: true
  validates :is_published, inclusion: [true, false]
  validates :slug, presence: true

  validates_uniqueness_of :name, scope: :user
  validates_uniqueness_of :slug

  validates_format_of :slug, with: /\A[A-Za-z0-9][A-Za-z0-9-]+\Z/
  validates_exclusion_of :slug, in: ['app', 'pages', 'admin', 'tmp', 'public', 'support', 'help', 'rails', 'api']
  validates_format_of :name, with: /\A[A-Za-z0-9][A-Za-z0-9 ]+\Z/

  belongs_to :user
  has_many :publication_views, -> { order('created_at') }, dependent: :destroy

  scope :published, -> { where(is_published: true) }

  has_attached_file :pdf, styles: {
    thumb: ["100x100#", :png]
  }, convert_options: {
    thumb: "-density 300"
  }
  validates_attachment :pdf, content_type: { content_type: ["application/pdf"] }

  before_validation :fill_guid, on: :create
  before_validation :set_new_status, on: :create
  before_validation :set_publication, on: :create
  before_validation :ensure_newline_at_end

  before_save :update_pdf_attachment, if: :content_changed?
  before_save :increment_edition, if: Proc.new { |resume| !resume.new_record? && resume.content_changed? }

  after_update :did_publish, if: Proc.new { |resume| resume.is_published_changed? && resume.is_published && !resume.is_published_was }
  after_update :did_unpublish, if: Proc.new { |resume| resume.is_published_changed? && !resume.is_published && resume.is_published_was }

  def resume_data(reload = false)
    if reload
      @resume_data = ResumeTools::Resume.from_text(content || '')
    else
      @resume_data ||= ResumeTools::Resume.from_text(content || '')
    end
  end
  alias :data :resume_data

  def generate_pdf_data
    resume_data.render_pdf
  end

  def generate_plain_text
    resume_data.render_plain_text
  end

  def generate_json_text
    resume_data.render_json
  end

  def structure
    JSON.parse(generate_json_text)
  end

  def descriptor
    selector = lambda { |sections|
      fragments = []
      sections.each do |section|
        if section.has_title?
          fragments << section.title
        end

        if section.has_para?
          segmenter = PragmaticSegmenter::Segmenter.new(text: section.para)
          fragments << segmenter.segment.first
          return fragments
        elsif section.has_items?
          segmenter = PragmaticSegmenter::Segmenter.new(text: section.items[0].text)
          fragments << segmenter.segment.first
          return fragments
        elsif section.has_periods?
          fragments << section.periods[0].title
        end
      end
    }

    text = selector.call(data.sections).join(' - ')
    text.blank? ? 'No content' : text
  end

  private

  def fill_guid
    self.guid ||= SecureRandom.hex(16)
  end

  def set_new_status
    self.status ||= 1
  end

  def set_publication
    self.is_published = false
    always_pass_this_filter = true
  end

  def update_pdf_attachment
    file_data = StringIO.new(generate_pdf_data)
    resume = self
    file_data.define_singleton_method :original_filename do
      "#{resume.guid}.pdf"
    end

    self.pdf = file_data
  end

  def ensure_newline_at_end
    if content.last != "\n"
      content << "\n"
    end
  end

  def increment_edition
    self.edition += 1
  end

  def did_publish
    Rails.logger.debug "DID PUBLISH"
  end

  def did_unpublish
    Rails.logger.debug "DID UNPUBLISH"
  end
end

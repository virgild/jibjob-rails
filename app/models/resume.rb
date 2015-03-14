# == Schema Information
#
# Table name: resumes
#
#  id               :integer          not null, primary key
#  user_id          :integer          not null
#  name             :string           not null
#  content          :text             not null
#  guid             :string           not null
#  status           :integer          default(0), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#  pdf_file_name    :string
#  pdf_content_type :string
#  pdf_file_size    :integer
#  pdf_updated_at   :datetime
#  edition          :integer          default(0), not null
#  slug             :string           not null
#  is_published     :boolean          default(FALSE), not null
#  access_code      :string
#  pdf_edition      :integer          default(0), not null
#
# Indexes
#
#  index_resumes_on_slug  (slug) UNIQUE
#

class Resume < ActiveRecord::Base
  HUMANIZED_ATTRIBUTES ||= {
    slug: "Link name"
  }

  NAME_MIN_LENGTH = 5
  NAME_MAX_LENGTH = 25
  SLUG_MIN_LENGTH = 4
  SLUG_MAX_LENGTH = 25

  validates :user, presence: true
  validates :guid, presence: true, uniqueness: true
  validates :status, presence: true, numericality: true
  validates :edition, presence: true, numericality: true
  validates :pdf_edition, presence: true, numericality: true
  validates :is_published, inclusion: [true, false]

  validates_uniqueness_of :name, scope: :user
  validates_uniqueness_of :slug

  validates_format_of :slug, with: /\A[A-Za-z0-9][A-Za-z0-9-]+\Z/, message: "should contain only text and dashes (eg. \"my-resume\")", unless: "slug.blank?"
  validates_exclusion_of :slug, in: ['app', 'pages', 'admin', 'tmp', 'public', 'support', 'help', 'rails', 'api'], message: "has already been taken", unless: "slug.blank?"
  validates_format_of :name, with: /\A[A-Za-z0-9][A-Za-z0-9 ]+\Z/, unless: "name.blank?"
  validates_length_of :name, in: NAME_MIN_LENGTH..NAME_MAX_LENGTH
  validates_length_of :slug, in: SLUG_MIN_LENGTH..SLUG_MAX_LENGTH
  validates_length_of :access_code, in: 4..16, allow_nil: true, allow_blank: true

  belongs_to :user
  has_many :publication_views, -> { order('created_at desc') }, dependent: :destroy

  scope :published, -> { where(is_published: true) }

  has_attached_file :pdf, styles: {
    thumb: ["100x100#", :png]
  }, convert_options: {
    thumb: "-density 300"
  }, path: Proc.new {
    if Rails.env == 'test'
      ':rails_root/public/test/:class/:attachment/:id_partition/:style/:filename'
    else
      ':rails_root/public/system/:class/:attachment/:id_partition/:style/:filename'
    end
  }
  validates_attachment :pdf, content_type: { content_type: ["application/pdf"] }

  before_validation :fill_guid, on: :create
  before_validation :set_new_status, on: :create
  before_validation :set_publication, on: :create
  before_validation :ensure_content_footer

  before_save :increment_edition, on: [:create, :update], if: Proc.new { |resume| resume.content_changed? }
  before_create :update_pdf_attachment

  after_commit :queue_pdf_refresh, on: :update, if: Proc.new { |resume| !resume.pdf_file_synced? }

  after_update :did_publish, if: Proc.new { |resume| resume.is_published_changed? && resume.is_published && !resume.is_published_was }
  after_update :did_unpublish, if: Proc.new { |resume| resume.is_published_changed? && !resume.is_published && resume.is_published_was }

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

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
          return fragments
        else
          return fragments
        end
      end
    }

    text = selector.call(data.sections).join(' - ')
    text.blank? ? 'No content' : text
  end

  def total_page_views
    publication_views.count
  end

  def requires_access_code?
    access_code.present?
  end

  def hourly_stats_for(start_date, end_date)
    stat_keys = ResumeStats.hourly_stats_keys_for(start_date, end_date)
    stat_values = REDIS_POOL.hmget("resume-#{id}-stats", *stat_keys)
    date_values = stat_keys.map { |key|
      date = DateTime.strptime(key, "day-%Y-%j-%H").in_time_zone(user.timezone)
      [date.year, date.month, date.day, date.hour]
    }
    date_values.zip(stat_values.map { |count| count.to_i || 0 }).map { |row| row.flatten }
  end

  def update_pdf_attachment
    file_data = StringIO.new(generate_pdf_data)
    resume = self
    file_data.define_singleton_method :original_filename do
      "#{resume.guid}.pdf"
    end

    self.pdf = file_data
    self.pdf_edition = edition
  end

  def pdf_file_synced?
    pdf_edition == edition
  end

  def recently_new?
    created_at > 30.minutes.ago
  end

  private

  def ensure_content_footer
    if (content == '') || (content.last != "\n")
      content << "\n"
    end
  end

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

  def queue_pdf_refresh
    PdfRefreshJob.perform_later(self)
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

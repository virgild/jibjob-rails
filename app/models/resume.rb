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

require 'render_anywhere'

class Resume < ActiveRecord::Base
  include RenderAnywhere

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
  validates_length_of :content, maximum: 50_000

  belongs_to :user
  has_many :publication_views, -> { order('created_at desc') }, dependent: :destroy

  scope :published, -> { where(is_published: true) }
  scope :list, -> { select(self.column_names - ["content", "pdf_content_type", "pdf_file_size", "pdf_updated_at"]) }
  scope :recently_updated, -> { order('updated_at DESC') }

  has_attached_file :pdf, { styles: {
      thumb: ["500", :jpg]
    }, convert_options: {
      thumb: "-background white"
    }
  }.merge(Rails.configuration.x.paperclip.storage_options)

  validates_attachment :pdf, content_type: { content_type: ["application/pdf"] }

  after_initialize :set_zero_page_count

  before_validation :fill_guid, on: :create
  before_validation :set_new_status, on: :create
  before_validation :set_publication, on: :create
  before_validation :set_default_theme, on: :create
  before_validation :ensure_content_footer

  before_save :increment_edition, on: [:create, :update], if: Proc.new { |resume| resume.content_changed? }
  before_create :update_pdf_attachment

  after_commit :queue_pdf_refresh, on: :update, if: Proc.new { |resume| !resume.pdf_file_synced? || resume.unmark_for_theme_update_refresh }

  after_update :did_publish, if: Proc.new { |resume| resume.is_published_changed? && resume.is_published && !resume.is_published_was }
  after_update :did_unpublish, if: Proc.new { |resume| resume.is_published_changed? && !resume.is_published && resume.is_published_was }
  after_update :mark_for_theme_update_refresh, if: -> (resume) { resume.theme != resume.theme_was }

  after_commit :delete_stored_stats, on: :destroy

  def self.human_attribute_name(attr, options = {})
    HUMANIZED_ATTRIBUTES[attr.to_sym] || super
  end

  def self.most_recently_updated
    recently_updated.first
  end

  def self.list_with_update_timestamps
    list.pluck(:id, :updated_at)
  end

  def resume_data(reload = false)
    if reload
      @resume_data = ResumeTools::Resume.from_text(content || '')
    else
      @resume_data ||= ResumeTools::Resume.from_text(content || '')
    end
  end
  alias :data :resume_data

  #TODO: Make composable pipeline
  def generate_pdf_data
    pages = 0

    # Render the PDF data to string
    pdf_data = WickedPdf.new.pdf_from_string(
      ResumeRenderer.new(self).render_theme(self.current_theme, layout: 'pdf_page'),
      {
        disable_external_links: true,
        disable_internal_links: true,
        print_media_type: true,
        outline: { outline: true }
      }
    )

    # Extract the PDF metadata
    meta_dump = nil
    IO.popen("#{ENV['PDFTK_BIN']} - dump_data_utf8 output -", "w+") do |pipe|
      pipe.write pdf_data
      pipe.close_write
      meta_dump = pipe.read
    end

    # Mutate some PDF metadata values
    # meta_dump.gsub!(/^InfoBegin\nInfoKey:\ Creator\nInfoValue:\ .+\n/, "InfoBegin\nInfoKey: Creator\nInfoValue: JibJob PDF Renderer\n")
    # meta_dump.gsub!(/^InfoBegin\nInfoKey:\ Producer\nInfoValue:\ .+\n/, "InfoBegin\nInfoKey: Producer\nInfoValue: https://jibjob.co\n")

    # # Inject updated PDF metadata back
    # begin
    #   dump_tmpfile = Tempfile.new("jibjob-resume-#{self.id}")
    #   dump_tmpfile.write(meta_dump)
    #   dump_tmpfile.rewind
    #   IO.popen("#{ENV['PDFTK_BIN']} - update_info_utf8 #{dump_tmpfile.path} output - uncompress", "w+") do |pipe|
    #     pipe.write pdf_data
    #     pipe.close_write
    #     pdf_data = pipe.read
    #   end
    # ensure
    #   dump_tmpfile.close
    #   dump_tmpfile.unlink
    # end

    # Fetch some PDF metadata values
    pages = meta_dump.match(/^NumberOfPages:\ (\d+)\n/)[1].to_i

    # Return PDF data wrapper
    { content: pdf_data,
      pages: pages
    }
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

  def current_theme
    self.theme || 'default'
  end

  def total_page_views
    self.publication_views_count
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
    pdf_data = generate_pdf_data
    file_data = StringIO.new(pdf_data[:content])
    resume = self
    file_data.define_singleton_method :original_filename do
      "#{resume.guid}.pdf"
    end

    self.pdf = file_data
    self.pdf_edition = edition
    self.pdf_pages = pdf_data[:pages]
  end

  def pdf_file_synced?
    pdf_edition == edition
  end

  def recently_new?
    new_record? ? true : (created_at > 30.minutes.ago)
  end

  def cache_key
    "resume/#{self.id}/:#{updated_at.to_i}:#{cached_total_page_views}"
  end

  def publication_view_stats_key
    "resume-#{self.id}-stats"
  end

  def delete_stored_stats
    REDIS_POOL.del(self.publication_view_stats_key)
  end

  def cached_total_page_views
    Resume.cached_total_page_views_for(user_id, id)
  end

  def increment_cached_total_page_views
    Resume.increment_cached_total_page_views_for(user_id, id)
  end

  def self.cached_total_page_views_for(user_id, resume_id)
    REDIS_POOL.hget("user-#{user_id}-cached_total_page_views", resume_id).try(:to_i) || 0
  end

  def self.increment_cached_total_page_views_for(user_id, resume_id)
    REDIS_POOL.hincrby("user-#{user_id}-cached_total_page_views", resume_id, 1)
  end

  protected

  def mark_for_theme_update_refresh
    key = "user:#{self.user_id}-resume:#{self.id}-theme_update_refresh"
    REDIS_POOL.set(key, 1)
    REDIS_POOL.expire(key, 1.day)
  end

  def unmark_for_theme_update_refresh
    REDIS_POOL.del("user:#{self.user_id}-resume:#{self.id}-theme_update_refresh") == 1
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

  def set_zero_page_count
    self.pdf_pages ||= 0
  end

  def set_default_theme
    self.theme = 'default' if self.theme.blank?
  end
end

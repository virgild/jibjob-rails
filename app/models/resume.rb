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

  belongs_to :user

  has_attached_file :pdf, styles: {
    thumb: ["100x100#", :png]
  }, convert_options: {
    thumb: "-density 300"
  }
  validates_attachment :pdf, content_type: { content_type: ["application/pdf"] }

  before_validation :fill_guid, on: :create
  before_validation :set_new_status, on: :create
  before_validation :set_publication, on: :create

  before_save :update_pdf_attachment, if: :content_changed?
  before_save :increment_edition, if: Proc.new { |resume| !resume.new_record? && resume.content_changed? }

  def resume_data(reload = false)
    if reload
      @resume_data = ResumeTools::Resume.from_text(content)
    else
      @resume_data ||= ResumeTools::Resume.from_text(content)
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

  def increment_edition
    self.edition += 1
  end
end

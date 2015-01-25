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
#

class Resume < ActiveRecord::Base
  validates :user, presence: true
  validates :name, presence: true
  validates :guid, presence: true, uniqueness: true
  validates :status, presence: true, numericality: true

  validates_uniqueness_of :name, scope: :user

  belongs_to :user
  has_many :publications

  has_attached_file :pdf, styles: {
    thumb: ["100x100#", :png]
  }
  validates_attachment :pdf, content_type: { content_type: ["application/pdf"] }

  before_validation :fill_guid
  before_validation :set_new_status

  before_save :convert_content_linefeeds
  after_save :update_pdf_attachment

  def fill_guid
    self.guid ||= SecureRandom.hex(16)
  end

  def set_new_status
    self.status ||= 1
  end

  def resume_data
    ResumeTools::Resume.from_text(content)
  end

  def generate_pdf_data
    resume_data.render_pdf
  end

  def generate_plain_text
    resume_data.render_plain_text
  end

  def generate_json_text
    resume_data.render_json
  end

  def update_pdf_attachment
    file_data = StringIO.new(generate_pdf_data)
    resume = self
    file_data.define_singleton_method :original_filename do
      "#{resume.guid}.pdf"
    end

    self.pdf = file_data
    save
  end

  def convert_content_linefeeds
    content.gsub!(/\r\n/, "\n")
  end
end

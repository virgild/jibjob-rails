# == Schema Information
#
# Table name: resumes
#
#  id         :integer          not null, primary key
#  user_id    :integer          not null
#  name       :string           not null
#  slug       :string           not null
#  content    :text             not null
#  guid       :string           not null
#  status     :integer          default("0"), not null
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

class Resume < ActiveRecord::Base
  validates :user, presence: true
  validates :name, presence: true
  validates :slug, presence: true
  validates :guid, presence: true
  validates :status, presence: true, numericality: true

  belongs_to :user

  before_validation :fill_guid
  before_validation :set_new_status

  def fill_guid
    self.guid ||= SecureRandom.hex(16)
  end

  def set_new_status
    self.status ||= 1
  end
end
# == Schema Information
#
# Table name: publication_views
#
#  id         :integer          not null, primary key
#  resume_id  :integer          not null
#  ip_addr    :inet             not null
#  url        :string           not null
#  referrer   :string
#  user_agent :string
#  created_at :datetime         not null
#
# Indexes
#
#  index_publication_views_on_resume_id  (resume_id)
#

class PublicationView < ActiveRecord::Base
  validates :resume_id, presence: true
  validates :ip_addr, presence: true
  validates :url, presence: true

  belongs_to :resume
  has_one :user, through: :resume

  def timezone
    user.timezone
  end
end

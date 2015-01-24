# == Schema Information
#
# Table name: publications
#
#  id           :integer          not null, primary key
#  user_id      :integer          not null
#  resume_id    :integer          not null
#  status       :integer          default("0"), not null
#  slug         :string           not null
#  publish_date :datetime
#  created_at   :datetime         not null
#  updated_at   :datetime         not null
#
# Indexes
#
#  index_publications_on_slug  (slug) UNIQUE
#

class Publication < ActiveRecord::Base
  validates :user, presence: true
  validates :resume, presence: true
  validates :status, presence: true
  validates :slug, presence: true, uniqueness: true

  belongs_to :user
  belongs_to :resume

  def to_params
    self.slug
  end
end

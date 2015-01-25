# == Schema Information
#
# Table name: users
#
#  id              :integer          not null, primary key
#  username        :string           not null
#  email           :string           not null
#  password_digest :string           not null
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#  timezone        :string
#  default_role    :string
#

class User < ActiveRecord::Base
  has_many :resumes
  has_many :publications
  has_one :signup

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true
  validates :default_role, presence: true

  after_initialize :set_default_role

  def to_param
    self.username
  end

  private

  def set_default_role
    self.default_role ||= 'user'
  end
end

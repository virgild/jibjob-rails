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
#

class User < ActiveRecord::Base
  has_many :resumes

  validates :username, presence: true, uniqueness: true
  validates :email, presence: true, uniqueness: true

  def to_param
    self.username
  end
end

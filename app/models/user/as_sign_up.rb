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
#

class User::AsSignUp < ActiveType::Record[User]
  has_secure_password

  attribute :terms, :string

  validates :password, presence: true, confirmation: true
  validates :terms, presence: true, acceptance: true
end

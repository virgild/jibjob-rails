class User::AsSignUp < ActiveType::Record[User]
  has_secure_password

  attribute :terms, :string

  validates :password, presence: true, confirmation: true
  validates :terms, presence: true, acceptance: true
end
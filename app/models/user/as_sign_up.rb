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
#  default_role    :string
#  timezone        :string
#

class User::AsSignUp < ActiveType::Record[User]
  attribute :terms, :string
  attribute :signup_data, :hash, default: proc { Hash.new }

  validates :password, presence: true, confirmation: true
  validates :terms, presence: true, acceptance: true

  after_commit :save_signup_data, on: :create
  after_commit :create_signup_confirmation, on: :create
  after_commit :send_signup_confirmation_email, on: :create

  private

  def save_signup_data
    unless signup_data.empty?
      signup_data[:created_at] = signup_data[:created_at].to_i if signup_data[:created_at]
      signup_data[:user_id] = self.id

      signup = self.build_signup(signup_data)
      signup.save
    end
  end

  def create_signup_confirmation
    confirmation = self.build_signup_confirmation
    confirmation.save
  end

  def send_signup_confirmation_email
    AccountsMailer.signup_confirmation(self).deliver_later
  end

end

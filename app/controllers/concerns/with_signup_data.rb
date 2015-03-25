module WithSignupData
  extend ActiveSupport::Concern

  included do
    attribute :signup_data, :hash, default: proc { Hash.new }
    after_commit :save_signup_data, on: :create
  end

  def save_signup_data
    unless signup_data.empty?
      signup_data[:created_at] = signup_data[:created_at].to_i if signup_data[:created_at]
      signup_data[:user_id] = self.id
      self.create_signup(signup_data)
    end
  end
end
module User::Param
  extend ActiveSupport::Concern

  def to_param
    self.username
  end
end
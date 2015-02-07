class UserSerializer < BaseSerializer
  attributes :id, :username, :email, :created_at, :updated_at, :timezone, :default_role


end

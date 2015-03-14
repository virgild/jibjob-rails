class AddUsersAuthProviderIndex < ActiveRecord::Migration
  def change
    add_index(:users, :username)
    add_index(:users, :email)
    add_index(:users, :auth_provider)
    add_index(:users, [:auth_provider, :auth_uid])
  end
end

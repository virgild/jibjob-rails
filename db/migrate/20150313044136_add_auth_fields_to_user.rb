class AddAuthFieldsToUser < ActiveRecord::Migration
  def change
    add_column :users, :auth_provider, :string
    add_column :users, :auth_uid, :string
    add_column :users, :auth_name, :string
    add_column :users, :auth_token, :string
    add_column :users, :auth_secret, :string
    add_column :users, :auth_expires, :boolean
  end
end

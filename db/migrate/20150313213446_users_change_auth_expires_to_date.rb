class UsersChangeAuthExpiresToDate < ActiveRecord::Migration
  def change
    remove_column :users, :auth_expires
    add_column :users, :auth_expires, :datetime
  end
end

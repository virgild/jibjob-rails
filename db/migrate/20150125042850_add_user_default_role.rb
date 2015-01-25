class AddUserDefaultRole < ActiveRecord::Migration
  def change
    add_column :users, :default_role, :string
  end
end

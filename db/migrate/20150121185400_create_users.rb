class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users, id: :bigserial do |t|
      t.string :username, null: false
      t.string :email, null: false
      t.string :password_digest, null: false
      t.timestamps null: false
    end
  end
end

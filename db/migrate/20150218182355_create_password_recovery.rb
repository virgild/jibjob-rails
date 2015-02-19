class CreatePasswordRecovery < ActiveRecord::Migration
  def change
    create_table :password_recoveries, id: false do |t|
      t.bigint :user_id, primary_key: true
      t.string :token, null: false
      t.datetime :created_at
    end
  end
end

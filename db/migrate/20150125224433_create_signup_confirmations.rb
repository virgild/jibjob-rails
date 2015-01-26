class CreateSignupConfirmations < ActiveRecord::Migration
  def change
    create_table :signup_confirmations, id: false do |t|
      t.bigint :user_id, primary_key: true
      t.string :token, null: false
      t.datetime :confirmed_at
    end
  end
end

class AddSerialIds < ActiveRecord::Migration
  def change
    drop_table :signups
    create_table :signups, id: :bigserial do |t|
      t.bigint :user_id
      t.inet :ip_address
      t.string :user_agent
      t.json :extras
      t.datetime :created_at, null: false
    end

    drop_table :signup_confirmations
    create_table :signup_confirmations, id: :bigserial do |t|
      t.bigint :user_id
      t.string :token, null: false
      t.datetime :confirmed_at
    end

    drop_table :password_recoveries
    create_table :password_recoveries, id: :bigserial do |t|
      t.bigint :user_id
      t.string :token, null: false
      t.datetime :created_at
    end
  end
end

class CreateSignups < ActiveRecord::Migration
  def change
    create_table :signups, id: false do |t|
      t.bigint :user_id, primary_key: true
      t.inet :ip_address
      t.string :user_agent
      t.json :extras
      t.datetime :created_at, null: false
    end
  end
end

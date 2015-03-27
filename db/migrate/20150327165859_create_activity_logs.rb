class CreateActivityLogs < ActiveRecord::Migration
  def change
    create_table :activity_logs, id: :bigserial do |t|
      t.bigint :user_id, null: false
      t.string :event, null: false
      t.string :url, null: false
      t.inet :ip_address
      t.integer :user_agent_id
      t.jsonb :metadata
      t.datetime :created_at, null: false
    end
  end
end

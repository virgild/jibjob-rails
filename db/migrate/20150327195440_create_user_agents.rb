class CreateUserAgents < ActiveRecord::Migration
  def change
    create_table :user_agents do |t|
      t.string :agent_id, null: false
      t.string :agent_string, null: false
    end

    add_index :user_agents, [:agent_id], unique: true
  end
end

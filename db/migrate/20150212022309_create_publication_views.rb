class CreatePublicationViews < ActiveRecord::Migration
  def change
    create_table :publication_views, id: :bigserial do |t|
      t.bigint :resume_id, null: false
      t.inet :ip_addr, null: false
      t.string :url, null: false
      t.string :referrer
      t.string :user_agent
      t.datetime :created_at, null: false
    end

    add_index :publication_views, [:resume_id]
  end
end

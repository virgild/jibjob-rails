class CreateResumes < ActiveRecord::Migration
  def change
    create_table :resumes, id: :bigserial do |t|
      t.bigint :user_id, null: false
      t.string :name, null: false
      t.string :slug, null: false
      t.text :content, null: false
      t.string :guid, null: false
      t.integer :status, null: false, default: 0
      t.timestamps null: false
    end
  end
end

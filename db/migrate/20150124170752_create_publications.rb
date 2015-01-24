class CreatePublications < ActiveRecord::Migration
  def change
    remove_column :resumes, :slug

    add_column(:resumes, :edition, :integer, { default: 1 })

    create_table :publications, id: :bigserial do |t|
      t.bigint :user_id, null: false
      t.bigint :resume_id, null: false
      t.integer :status, null: false, default: 0
      t.string :slug, null: false
      t.datetime :publish_date
      t.timestamps null: false
    end

    add_index :publications, :slug, unique: true
  end
end

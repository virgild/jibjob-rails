class AddResumeSlug < ActiveRecord::Migration
  def change
    add_column :resumes, :slug, :string, null: false
    add_column :resumes, :is_published, :boolean, null: false, default: false
    add_index :resumes, :slug, unique: true
  end
end

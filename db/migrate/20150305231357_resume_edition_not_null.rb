class ResumeEditionNotNull < ActiveRecord::Migration
  def change
    change_column :resumes, :edition, :integer, { default: 0, null: false }
    change_column :resumes, :pdf_edition, :integer, { default: 0, null: false }
  end
end

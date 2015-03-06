class AddResumePdfEdition < ActiveRecord::Migration
  def change
    add_column :resumes, :pdf_edition, :integer, { default: 0 }
    change_column :resumes, :edition, :integer, { default: 0 }
  end
end

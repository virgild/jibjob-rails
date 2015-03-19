class AddResumePdfPages < ActiveRecord::Migration
  def change
    add_column :resumes, :pdf_pages, :integer
  end
end

class AddPdfToResume < ActiveRecord::Migration
  def change
    add_attachment :resumes, :pdf
  end
end

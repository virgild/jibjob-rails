class AddResumeAccessCode < ActiveRecord::Migration
  def change
    add_column :resumes, :access_code, :string
  end
end

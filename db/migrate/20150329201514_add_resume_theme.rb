class AddResumeTheme < ActiveRecord::Migration
  def change
    add_column :resumes, :theme, :string
  end
end

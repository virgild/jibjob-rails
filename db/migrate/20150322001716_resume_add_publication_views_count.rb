class ResumeAddPublicationViewsCount < ActiveRecord::Migration
  def change
    add_column :resumes, :publication_views_count, :bigint, null: false, default: 0
  end
end

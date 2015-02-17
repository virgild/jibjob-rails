class PublicationViewLocations < ActiveRecord::Migration
  def change
    add_column :publication_views, :city, :string
    add_column :publication_views, :state, :string
    add_column :publication_views, :country, :string
  end
end

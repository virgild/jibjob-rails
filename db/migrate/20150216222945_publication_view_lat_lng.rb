class PublicationViewLatLng < ActiveRecord::Migration
  def change
    add_column :publication_views, :lat, :decimal, precision: 9, scale: 6
    add_column :publication_views, :lng, :decimal, precision: 9, scale: 6
  end
end

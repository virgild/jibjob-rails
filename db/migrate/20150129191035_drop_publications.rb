class DropPublications < ActiveRecord::Migration
  def change
    drop_table :publications
  end
end

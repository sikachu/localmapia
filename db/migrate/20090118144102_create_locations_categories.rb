class CreateLocationsCategories < ActiveRecord::Migration
  def self.up
    create_table :locations_categories, :id => false do |t|
      t.integer :location_id
      t.integer :category_id
    end
  end

  def self.down
    drop_table :locations_categories
  end
end

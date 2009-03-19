class CreateLocationRegions < ActiveRecord::Migration
  def self.up
    create_table :location_regions do |t|
      t.integer :location_id
      t.float :lat
      t.float :lng

      t.timestamps
    end
  end

  def self.down
    drop_table :location_regions
  end
end

class AddPermalinkToLocations < ActiveRecord::Migration
  def self.up
    add_column :locations, :permalink, :string
  end

  def self.down
    remove_column :locations, :permalink
  end
end

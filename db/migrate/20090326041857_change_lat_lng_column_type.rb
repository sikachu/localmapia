class ChangeLatLngColumnType < ActiveRecord::Migration
  def self.up
    change_column :location_regions, :lat, :decimal, :precision => 20, :scale => 16
    change_column :location_regions, :lng, :decimal, :precision => 20, :scale => 16
    change_column :location_versions, :lat, :decimal, :precision => 20, :scale => 16
    change_column :location_versions, :lng, :decimal, :precision => 20, :scale => 16
    change_column :locations, :lat, :decimal, :precision => 20, :scale => 16
    change_column :locations, :lng, :decimal, :precision => 20, :scale => 16
  end

  def self.down
  end
end

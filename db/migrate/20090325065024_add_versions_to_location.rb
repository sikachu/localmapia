class AddVersionsToLocation < ActiveRecord::Migration
  def self.up
    add_column :locations, :version, :integer
    Location.create_versioned_table
  end

  def self.down
    Location.drop_versioned_table
    remove_column :locations, :version
  end
end

class AddVersionToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :version, :integer
    Event.create_versioned_table
  end

  def self.down
    Event.drop_versioned_table
    remove_column :events, :version
  end
end

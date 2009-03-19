class CreateLocationsTags < ActiveRecord::Migration
  def self.up
    create_table :locations_tags, :id => false  do |t|
      t.integer :location_id
      t.integer :tag_id
    end
  end

  def self.down
    drop_table :locations_tags
  end
end

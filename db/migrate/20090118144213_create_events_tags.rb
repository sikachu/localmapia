class CreateEventsTags < ActiveRecord::Migration
  def self.up
    create_table :events_tags, :id => false  do |t|
      t.integer :event_id
      t.integer :tag_id
    end
  end

  def self.down
    drop_table :events_tags
  end
end

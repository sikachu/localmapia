class CreateEventPhotos < ActiveRecord::Migration
  def self.up
    create_table :event_photos do |t|
      t.integer :event_id
      t.string :title
      t.string :photo
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :event_photos
  end
end

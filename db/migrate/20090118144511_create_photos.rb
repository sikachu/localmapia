class CreatePhotos < ActiveRecord::Migration
  def self.up
    create_table :photos do |t|
      t.integer :user_id
      t.integer :location_id
      t.integer :event_id
      t.string :album_type
      t.string :photo_url
      t.string :original_url

      t.timestamps
    end
  end

  def self.down
    drop_table :photos
  end
end

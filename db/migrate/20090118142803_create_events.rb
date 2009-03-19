class CreateEvents < ActiveRecord::Migration
  def self.up
    create_table :events do |t|
      t.integer :location_id
      t.string :name
      t.text :description
      t.string :url
      t.date :date_start
      t.date :date_end
      t.time :time_start
      t.time :time_end
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :events
  end
end

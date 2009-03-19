class CreateFeedbacks < ActiveRecord::Migration
  def self.up
    create_table :feedbacks do |t|
      t.integer :location_id
      t.integer :event_id
      t.integer :user_id
      t.text :content
      t.integer :rank
      t.string :status

      t.timestamps
    end
  end

  def self.down
    drop_table :feedbacks
  end
end

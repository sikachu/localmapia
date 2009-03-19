class CreateReports < ActiveRecord::Migration
  def self.up
    create_table :reports do |t|
      t.integer :user_id
      t.string :object_type
      t.integer :object_id
      t.text :content

      t.timestamps
    end
  end

  def self.down
    drop_table :reports
  end
end

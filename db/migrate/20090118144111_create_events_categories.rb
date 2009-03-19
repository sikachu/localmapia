class CreateEventsCategories < ActiveRecord::Migration
  def self.up
    create_table :events_categories, :id => false do |t|
      t.integer :event_id
      t.integer :category_id
    end
  end

  def self.down
    drop_table :events_categories
  end
end

class CreateSearches < ActiveRecord::Migration
  def self.up
    create_table :searches do |t|
      t.string :keyword
      t.string :permalink
      t.text :sorted_by_relevance
      t.text :sorted_by_added
      t.text :sorted_by_updated

      t.timestamps
    end
  end

  def self.down
    drop_table :searches
  end
end

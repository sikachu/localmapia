class CreateLocations < ActiveRecord::Migration
  def self.up
    create_table :locations do |t|
      t.integer :user_id
      t.integer :parent_id
      t.string :title
      t.text :description
      t.float :lat
      t.float :lng
      t.string :city
      t.string :province
      t.string :country
      t.string :status
      t.integer :score
      t.integer :vote_count
      t.text :additional_info

      t.timestamps
    end
  end

  def self.down
    drop_table :locations
  end
end

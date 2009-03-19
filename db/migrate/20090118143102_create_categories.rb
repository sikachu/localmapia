class CreateCategories < ActiveRecord::Migration
  def self.up
    create_table :categories do |t|
      t.integer :parent_id
      t.string :title
      t.text :description
      t.string :navigation
      t.string :photo
      t.string :category_type
    end
  end

  def self.down
    drop_table :categories
  end
end

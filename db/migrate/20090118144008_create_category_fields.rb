class CreateCategoryFields < ActiveRecord::Migration
  def self.up
    create_table :category_fields do |t|
      t.integer :category_id
      t.string :name
      t.string :field_type
      t.text :collection
    end
  end

  def self.down
    drop_table :category_fields
  end
end

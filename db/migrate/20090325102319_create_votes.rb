class CreateVotes < ActiveRecord::Migration
  def self.up
    create_table :votes do |t|
      t.integer :user_id
      t.integer :votable_id
      t.string :votable_type

      t.timestamps
    end
  end

  def self.down
    drop_table :votes
  end
end

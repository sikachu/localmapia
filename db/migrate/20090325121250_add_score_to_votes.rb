class AddScoreToVotes < ActiveRecord::Migration
  def self.up
    add_column :votes, :score, :float
  end

  def self.down
    remove_column :votes, :score
  end
end

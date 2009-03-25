class RemoveVoteCountAndScoreFromLocation < ActiveRecord::Migration
  def self.up
    remove_column :locations, :vote_count
    remove_column :locations, :score
  end

  def self.down
    add_column :locations, :score, :integer
    add_column :locations, :vote_count, :integer
  end
end

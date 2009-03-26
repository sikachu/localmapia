class RemoveScoreAndVoteCountFromLocationVersions < ActiveRecord::Migration
  def self.up
    remove_column :location_versions, :score
    remove_column :location_versions, :vote_count
  end

  def self.down
    add_column :location_versions, :vote_count, :integer
    add_column :location_versions, :score, :integer
  end
end

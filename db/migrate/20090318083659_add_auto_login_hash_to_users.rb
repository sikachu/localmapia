class AddAutoLoginHashToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :auto_login_hash, :string
  end

  def self.down
    remove_column :users, :auto_login_hash
  end
end

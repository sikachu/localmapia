class CreateUsers < ActiveRecord::Migration
  def self.up
    create_table :users do |t|
      t.string :email
      t.string :encrypted_password
      t.string :salt
      t.string :displayname
      t.string :city
      t.string :province
      t.string :country
      t.string :status
      t.string :activation_key
      t.datetime :activated_at
      t.string :password_reset_key
      t.date :last_logged_in

      t.timestamps
    end
  end

  def self.down
    drop_table :users
  end
end

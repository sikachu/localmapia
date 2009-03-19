class CreateEventLogs < ActiveRecord::Migration
  def self.up
    create_table :event_logs do |t|
      t.integer :user_id
      t.string :action
      t.text :content
      t.string :ip_address
      t.string :user_agent

      t.timestamps
    end
  end

  def self.down
    drop_table :event_logs
  end
end

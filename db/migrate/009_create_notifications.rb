class CreateNotifications < ActiveRecord::Migration
  def self.up
    create_table :notifications do |t|
      t.integer :event_id
      t.integer :user_id
      t.boolean :sent
    end
  end

  def self.down
    drop_table :notifications
  end
end

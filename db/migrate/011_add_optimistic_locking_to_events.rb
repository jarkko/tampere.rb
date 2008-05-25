class AddOptimisticLockingToEvents < ActiveRecord::Migration
  def self.up
    add_column :events, :lock_version, :integer, :default => 0
  end

  def self.down
    remove_column :events, :lock_version
  end
end

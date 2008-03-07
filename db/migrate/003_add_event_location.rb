class AddEventLocation < ActiveRecord::Migration
  def self.up
    add_column :events, :location_id, :integer, :nil => false
  end

  def self.down
    remove_column :events, :location_id
  end
end

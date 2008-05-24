class AddParticipationId < ActiveRecord::Migration
  def self.up
    add_column :participations, :id, :integer
  end

  def self.down
    remove_column :participations, :id
  end
end

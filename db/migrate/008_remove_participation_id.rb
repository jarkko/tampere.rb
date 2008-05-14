class RemoveParticipationId < ActiveRecord::Migration
  def self.up
    remove_column :participations, :id
  end

  def self.down
    add_column :participations, :id
  end
end

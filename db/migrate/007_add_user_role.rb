class AddUserRole < ActiveRecord::Migration
  def self.up
    add_column :users, :role, :string
    User.find(:all).each do |u|
      u.update_attribute(:role, 'member')
    end
  end

  def self.down
    remove_column :users, :role
  end
end

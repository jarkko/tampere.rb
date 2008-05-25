class AddUserWebPageAndDescription < ActiveRecord::Migration
  def self.up
    add_column :users, :web_page, :string
    add_column :users, :description, :text
  end

  def self.down
    remove_column :users, :web_page
    remove_column :users, :description
  end
end

class AddAboutPageInfo < ActiveRecord::Migration
  def self.up
    create_table :about_page do |t|
      t.text :content
    end
  end

  def self.down
  end
end

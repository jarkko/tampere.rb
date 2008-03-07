class Event < ActiveRecord::Base
  belongs_to :location

  def self.find_recent(count)
    self.find(:all, :order => 'date DESC', :limit => count)
  end
end

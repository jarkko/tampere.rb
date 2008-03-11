class Event < ActiveRecord::Base
  belongs_to :location
  
  validates_uniqueness_of :date

  def self.find_recent(count)
    self.find(:all, :order => 'date DESC', :limit => count)
  end
end

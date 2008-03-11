class Event < ActiveRecord::Base
  belongs_to :location
  
  validates_uniqueness_of :date

  def self.find_recent(count)
    self.find(:all, :order => 'date DESC', :limit => count)
  end

  def self.new_default
    self.new(:date => default_event_date)
  end
  
  private
  
  def self.default_event_date
    most_recent = Event.find(:all, :order => 'date DESC', :limit => 1)[0]
    default_date = most_recent.date + 1.day

    rec = Recurrence.new(Date.parse(default_date.strftime('%Y-%m-%d')),
                         :day_of_month => :thursday, 
                         :every => :first)
    rec.next[0]
  end
end

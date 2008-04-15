class Event < ActiveRecord::Base
  belongs_to :location

  has_many :participations
  has_many :attendees, :through => :participations, :source => :user

  attr_protected :role

  validates_presence_of :date, :message => "päiväys puuttuu"
  validates_uniqueness_of :date, :message => 'päiväys jo käytetty'
  validates_presence_of :description, :message => 'ohjelman sisältö puuttuu'

  #
  # Class methods
  #

  # Find count most recent events)
  def self.find_recent(count)
    find(:all, :order => 'date DESC', :limit => count)
  end

  # Find most recent event
  def self.find_most_recent
    find(:first, :order => 'date DESC')
  end

  # Find next upcoming event, returning nil if not found
  def self.find_upcoming
    # use Time.now or DateTime.now
    find(:first, :conditions => ['date >= ?', Time.now], :order => 'date ASC')
  end
  
  # Create new default event. In particular, set date default
  # to next recurring event date
  def self.new_default
    self.new(:date => default_event_date)
  end

  def self.register_user(event_id, user_id)
    self.find(event_id).attendees.create(:user_id => user_id)
  end

  def self.send_reminders_if_needed(days_before)
    evt = Event.find_upcoming
    return nil unless evt && evt.days_to <= days_before

    evt.attendees.each do |user|
      user.remind_of(evt) unless user.reminder_sent(evt)
    end
  end

  #
  # Instance methods
  #

  def registered_count
    self.attendees.size
  end

  def days_to
    (self.date.to_date - Time.now.to_date).to_i
  end
  
  private

  def self.default_event_date
    default_date = begin
      (find_most_recent.date + 1.day).to_date
    rescue NoMethodError => e
      Date.today
    end

    rec = Recurrence.new(default_date,
                         :day_of_month => :thursday,
                         :every => :first)
    rec.next[0]
  end
end

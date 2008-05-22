class Event < ActiveRecord::Base
  include Assert

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

  # Find #count most recent events, partitioned to coming and past
  def self.find_coming_and_past(count)
    day_start = Time.now.beginning_of_day
    find_recent(count).partition { |e| e.date >= day_start }
  end

  # Find most recent event
  def self.find_most_recent
    find(:first, :order => 'date DESC')
  end

  # Find next upcoming event, returning nil if not found
  def self.find_upcoming
    find(:first, :conditions => ['date >= ?', Time.now], :order => 'date ASC')
  end

  # Create new default event. In particular, set date default
  # to next recurring event date
  def self.new_default
    self.new(:date => default_event_date)
  end

  def self.register_user(event_id, user_id)
    evt = find event_id
    evt.participations.create(:user_id => user_id) unless
      evt.has_participant?(user_id)
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

  def has_participant?(user_id)
    self.participations.map(&:user_id).include? user_id
  end

  def location_name
    self.location ? location.title : location
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

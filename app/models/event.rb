class Event < ActiveRecord::Base
  belongs_to :location

  has_many :participations
  has_many :users, :through => :participations

  validates_uniqueness_of :date, :message => 'päiväys jo käytetty'
  validates_presence_of :description, :message => 'ohjelman sisältö puuttuu'

  #
  # Class methods
  #

  # find count most recent events)
  def self.find_recent(count)
    self.find(:all, :order => 'date DESC', :limit => count)
  end

  def self.new_default
    self.new(:date => default_event_date)
  end

  # find most recent event
  def self.find_most_recent
    Event.find(:first, :order => 'date DESC')
  end

  def self.register_user(event_id, user_id)
    self.find(event_id).participations.create(:user_id => user_id)
  end

  #
  # Instance methods
  #

  def registered_count
    self.participations.size
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

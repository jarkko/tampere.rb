module EventsHelper
  def fmt_date(dob)
    dob.strftime("%d.%m.%Y")
  end
  
  def event_default_date
    most_recent_event = Event.find(:all, :order => 'date DESC', :limit => 1)[0]
    default_date = most_recent_event.date + 1.day
    logger.debug("event is #{most_recent_event.inspect}, date is #{default_date}")
    rec = Recurrence.new(Date.parse(default_date.strftime('%Y-%m-%d')),
                         :day_of_month => :thursday, 
                         :every => :first)
    rec.next[0]
  end
end

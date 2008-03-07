module EventsHelper
  def fmt_date(dob)
    dob.strftime("%d.%m.%Y")
  end
  
  def event_default_date
    rec = Recurrence.new(Date.today, 
                         :day_of_month => :thursday, 
                         :every => :first)
    rec.next[0]
  end
end

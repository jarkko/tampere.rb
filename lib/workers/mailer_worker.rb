class MailerWorker < BackgrounDRb::MetaWorker
  set_worker_name :mailer_worker
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
    add_periodic_timer(interval_secs=3600) { remind_about_coming_event }
  end
  
  def remind_about_coming_event
    # evt = Event.find_upcoming
    # return nil unless evt && evt.days_to <= 7
    # evt.attendees.each do |user|
    #   user.remind_of(evt) unless user.reminder_sent(evt)
    # end
  end
end


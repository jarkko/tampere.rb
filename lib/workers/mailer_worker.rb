class MailerWorker < BackgrounDRb::MetaWorker
  set_worker_name :mailer_worker
  
  def create(args = nil)
    # this method is called, when worker is loaded for the first time
    add_periodic_timer(interval_secs=30) { remind_about_coming_event }
  end
  
  def remind_about_coming_event
    Event.send_reminders_if_needed(days_before=30)
  end
end


class MailerWorker < BackgrounDRb::MetaWorker
  set_worker_name :mailer_worker

  def create(args = nil)
    # this method is called, when worker is loaded for the first time
    add_periodic_timer(interval_secs=10) {
      # Problem: works only for the very next upcoming events
      remind_about_coming_event(days_before=7)
      remind_about_coming_event(days_before=2)
    }
    @sent_mails = { }
  end

  def remind_about_coming_event(days_before)
    evt = Event.find_upcoming
    return nil unless evt && evt.days_to == days_before

    evt.attendees.each do |user|
      key = notifier_ident(evt, user, days_before)
      unless @sent_mails.include? key
        logger.info("sending reminder to user #{user.id} about event #{evt.id}")
        EventNotifier.deliver_event_reminder(user, evt)
        @sent_mails[key] = Date.today
      end
    end
    purge_old_notification_entries(@sent_mails, delete_before=Date.today)
  end

  private

  def notifier_ident(evt, user, days_before)
    [evt.id, user.id, days_before].join ':'
  end

  def purge_old_notification_entries(sent_mails, delete_before)
    sent_mails.delete_if { |k,v| v < delete_before }
  end
end


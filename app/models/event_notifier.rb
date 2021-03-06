class EventNotifier < ActionMailer::Base
  helper :application
  include ApplicationHelper

  def event_reminder(recipient, event)
     recipients recipient.email
     from       "tampererb+noreply@majakari.net"
     subject    "Reminder: Tampere.rb meeting on #{fmt_date(event.date)}"
     body       :account => recipient, :event => event
  end
end

module EventsHelper
  def fmt_date(dob)
    dob.strftime("%d.%m.%Y")
  end

  def show_users(users)
    users.map {|u| u.login}.to_sentence(:connector => 'ja')
  end

  def format_event(evt)
    RedCloth.new(evt.description).to_html
  rescue Exception => e
    warn "RedCloth not installed!"
    evt.description
  end
end

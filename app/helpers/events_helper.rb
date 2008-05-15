module EventsHelper
  def preview_users(evt)
    users = evt.attendees
    names = users.map {|u| u.login}.to_sentence(:connector => 'ja', :skip_last_comma => true)
    count = names.empty? ? '-' : "(#{users.size})"
    [names, count].join(" ")
  end

  def show_users(users)
    content_tag(:ul, users.sort_by { |u| u.login.downcase }.map {|u| "<li>#{u.login}</li>"}.join)
  end

  def format_event(evt)
    RedCloth.new(evt.description).to_html
  rescue Exception => e
    warn "RedCloth not installed!"
    evt.description
  end

  def preview_event(evt)
    truncate(evt.description, 80)
  end
end

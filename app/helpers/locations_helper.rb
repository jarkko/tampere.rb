module LocationsHelper
  def popularity_of(loc)
    evt_count = Event.count
    return 0 if evt_count.zero?

    held_count = 0
    Event.find(:all).each do |evt|
      held_count += 1 if evt.location == loc
    end

    "%.1f%%" % [100*(held_count / evt_count.to_f)]
  end
end

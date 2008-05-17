module LocationsHelper
  def popularity_of(loc)
    evt_count = Event.count
    return 0 if evt_count.zero?

    c = Event.find(:all).select { |e| e.location == loc }.size
    "%.1f%%" % [100*(c / evt_count.to_f)]
  end
end

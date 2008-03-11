require 'date'
class Recurrence
  def initialize(date, opts)
    @base_date = date
    @opts = opts
    @current_date = @base_date.dup
  end
  
  def next(count=1)
    (1..count).map { 
      date = get_next_recurrence(@current_date)
      @current_date = date.succ # so that next actually moves forward
      date
    }
  end

  private
  
  def get_next_recurrence(date)
    if @opts[:day_of_month]
      wanted_index = dow_to_index(@opts[:day_of_month])
      cur_day_index = date.wday
      offset = wanted_index - cur_day_index
      offset += 7 if offset < 0
      date = date + offset
      
      if date.day > 7 # we are pass the first given date in current month
        date = get_next_recurrence(date.succ)
      end
    end
    date
  end
  
  def dow_to_index(date)
    abbr = date.to_s[0..2].capitalize
    Date::ABBR_DAYNAMES.index(abbr)
  end
end

if __FILE__ == $0
  rec = Recurrence.new(Date.today, :day_of_month => :monday, :every => :first)

  rec.next(13).each do |day|
    puts day
  end
end

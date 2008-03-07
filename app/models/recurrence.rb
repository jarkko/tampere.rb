
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
      dow_index = dow_to_index(@opts[:day_of_month])
      begin
        date = date.succ
      end while date.wday != dow_index
      
      if date.day > 7 # we are pass the first given date in current month
        cur_month = date.mon
        while (date.mon == cur_month)
          date = date + 7
        end
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

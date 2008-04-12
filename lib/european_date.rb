require 'date'
module EuropeanDate
  # parse european-style date and return it in ISO format
  def self.to_iso(date_str)
    begin
      DateTime.strptime(date_str, '%d.%m.%Y').strftime('%Y-%m-%d')
    rescue Exception => e
      raise e, "invalid date: #{date_str}"
    end
  end
end


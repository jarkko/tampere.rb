require 'date'
module EuropeanDate
  # parse european-style date and return it in ISO format
  def self.to_iso(date_str)
    DateTime.strptime(date_str, '%d.%m.%Y').strftime('%Y-%m-%d')
  end
end


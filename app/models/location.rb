class Location < ActiveRecord::Base
  has_many :events

  def self.find_by_id_or_build_by_name(hsh)
    title = hsh['location']
    title.blank? ? find(hsh['location_id']) : new(:title => title)
  end
end

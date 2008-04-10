class Location < ActiveRecord::Base
  has_many :events

  def self.find_by_id_or_build_by_name(loc_title, loc_id)
    loc_title.blank? ? find(loc_id) : new(:title => loc_title)
  end
end

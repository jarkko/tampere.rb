require File.dirname(__FILE__) + '/../spec_helper'

describe Location do
  it "can be built" do
    Location.new(:title => 'Ruby palace', 'address' => 'Heinemeier Road 42')
  end

  it "can be found by id and if not found, built by name" do
    loc = Location.find_by_id_or_build_by_name('foo', 1)
    loc.should be(:new_record)
  end
end

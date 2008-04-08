require File.dirname(__FILE__) + '/../spec_helper'

describe Location do
  it "can be built" do
    Location.new(:title => 'Ruby palace', 'address' => 'Heinemeier Road 42')
  end
end

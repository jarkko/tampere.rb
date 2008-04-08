require File.dirname(__FILE__) + '/../spec_helper'

describe Event do
  it "can build a default event" do
    Event.new_default
  end

  it "default events have date in future" do
    evt = Event.new_default
    evt.date > Date.today
  end

  it "can find most recent event" do
    Event.find_most_recent
  end

  it "can tell how many users are participating" do
    evt = Event.new
    evt.stub!(:participations).and_return(['joe', 'jack', 'alice'])
    evt.registered_count.should == 3
  end
end

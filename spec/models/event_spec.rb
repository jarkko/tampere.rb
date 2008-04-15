require File.dirname(__FILE__) + '/../spec_helper'

describe Event do

  describe "default" do
    it "can build a default event" do
      Event.new_default
    end

    it "has defaults date in future" do
      evt = Event.new_default
      evt.date > Date.today
    end
  end

  it "can find most recent event" do
    Event.find_most_recent
  end

  it "can tell how many users are attending" do
    evt = Event.new
    evt.stub!(:attendees).and_return(['joe', 'jack', 'alice'])
    evt.registered_count.should == 3
  end
  
  it "send_reminders_if_needed(days)"
end

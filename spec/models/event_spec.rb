require File.dirname(__FILE__) + '/../spec_helper'

describe Event do
  before(:each) do
    @joe = mock_model(Participation, :user_id => 1)
    # @mack = mock_model(Participation, :id => 2)
  end
  
  describe "default" do
    it "can be built" do
      Event.new_default
    end

    it "has default date in the future" do
      evt = Event.new_default
      evt.date > Date.today
    end
  end

  it "can be asked for most recent" do
    Event.find_most_recent
  end

  it "can tell how many users are attending it" do
    evt = Event.new
    evt.stub!(:attendees).and_return(['joe', 'jack', 'alice'])
    evt.registered_count.should == 3
  end
  
  it "has_participant? returns true given participating user's id" do
    evt = Event.new
    evt.participations << @joe
    evt.should have_participant(1)
  end
  
  it "has_participant? returns false given user id of non-participating user" do
    evt = Event.new
    evt.participations << @joe
    evt.should_not have_participant(2)
  end  
end

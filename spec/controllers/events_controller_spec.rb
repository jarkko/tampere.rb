require File.dirname(__FILE__) + '/../spec_helper'

describe EventsController do

  describe "GET /events" do
    it "should respond to index" do
      get :index
      response.should be_success
    end
  end

  describe "GET /events/1" do
    before(:each) do
      @event = mock('event')
      Event.stub!(:find).and_return(@event)
    end

    it "should GET an event" do
      get 'show', :id => 1
      puts response.body
      #response.should be_success
    end
  end
end

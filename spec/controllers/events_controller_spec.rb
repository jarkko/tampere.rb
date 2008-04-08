require File.dirname(__FILE__) + '/../spec_helper'

describe EventsController do
  include AuthenticatedTestHelper

  describe "GET /events" do
    it "should respond to index" do
      get :index
      response.should be_success
    end
  end

  describe "GET /events/archived" do
    it "should respond to index" do
      evt = mock('event', :date => Time.now)
      Event.should_receive(:find_recent).with(100).and_return([evt])
      get :archived
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
      #response.should be_success
    end
  end

  describe "GET /events/new" do
    it "should redirect unregistered users to same page and  to new" do
      Event.should_receive(:new_default).never
      get 'new'
      flash[:notice].should_not be_nil
    end

    it "should show new event form for registered users" do
      Event.should_receive(:new_default).once
      fake_login(1)
      get 'new'
      flash[:notice].should be_nil
      response.should be_success
    end
  end
end

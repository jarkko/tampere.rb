require File.dirname(__FILE__) + '/../spec_helper'

describe EventsController do
  include AuthenticatedTestHelper
  
  describe "all users" do
    
    it "should be able to get index" do
      get :index
      response.should be_success
    end
    
    it "should be able to get archived messages" do
      evt = mock('event', :date => Time.now)
      Event.should_receive(:find_recent).with(100).and_return([evt])
      get :archived
      response.should be_success
    end
    
    it "should be able to show an event" do
      @event = mock('event')
      Event.stub!(:find).and_return(@event)
      
      get 'show', :id => 1
      #response.should be_success
    end    

    it "should require registration when adding an event is attempted" do
      Event.should_receive(:new_default).never
      get 'new'
      flash[:notice].should_not be_nil
    end
    
  end # describe all users

  describe "registered users" do
    before(:each) do 
      fake_login(uid=1)
    end
    
    it "should be able to add new events" do
      Event.should_receive(:new_default).once
      
      get 'new'
      flash[:notice].should be_nil
      response.should be_success
    end
  
    it "should be able to edit an existing event" do
      evt = mock('event', 
                 :id => 1,
                 :description => 'desc', 'date' => 'a_date',
                 :location_id => 1)
      Event.stub!(:find).and_return(evt)
      fake_login(1)
      get :edit, :id => 1
      response.should be_success
    end    
    
    it "should be able to update an event" do
      warn("update_attributes expectation should be more precise")
      evt = mock_model(Event, 
                       :description => 'desc', 
                       :date => '2.1.2001', 
                       :location_id => 1)
      Event.should_receive(:find).with("1").and_return(evt)
      params = { 'description' => 'modified', 'date' => '22.2.2007' }
      evt.should_receive(:update_attributes).with(anything).and_return(true)
      put :update, :id => 1, :event => params
      flash[:notice].should_not be_nil
    end
  end # registered users
end

require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.
include AuthenticatedTestHelper

describe User do
  before(:each) do
    @joe_password = 'mypass'
    @joe = build_user(:login => 'joe',
                      :password => @joe_password,
                      :password_confirmation => @joe_password)
  end

  it 'requires login' do
    lambda do
      u = build_user(:login => nil)
      u.errors.on(:login).should_not be_nil
    end.should_not change(User, :count)
  end

  it 'requires password' do
    lambda do
      u = build_user(:password => nil)
      u.errors.on(:password).should_not be_nil
    end.should_not change(User, :count)
  end

  it 'requires password confirmation' do
    lambda do
      u = build_user(:password_confirmation => nil)
      u.errors.on(:password_confirmation).should_not be_nil
    end.should_not change(User, :count)
  end

  it 'requires email' do
    lambda do
      u = build_user(:email => nil)
      u.errors.on(:email).should_not be_nil
    end.should_not change(User, :count)
  end

  it 'resets password' do
    @joe.update_attributes(:password => 'new password',
                           :password_confirmation => 'new password')
    User.authenticate('joe', 'new password').should == @joe
  end

  it 'does not rehash password when authenticating' do
    warn_of_db_access
    @joe.update_attributes(:login => 'joe2')
    User.authenticate('joe2', @joe_password).should == @joe
  end

  it 'authenticates user' do
    User.should_receive(:find_by_login).with('joe').and_return(@joe)
    warn_of_db_access
    @joe.save!
    User.authenticate('joe', @joe_password).should == @joe
  end

  it 'sets remember token' do
    @joe.remember_me
    @joe.remember_token.should_not be_nil
    @joe.remember_token_expires_at.should_not be_nil
  end

  it 'unsets remember token' do
    @joe.remember_me
    @joe.remember_token.should_not be_nil
    @joe.forget_me
    @joe.remember_token.should be_nil
  end

  it 'remembers me for one week' do
    before = 1.week.from_now.utc
    @joe.remember_me_for 1.week
    after = 1.week.from_now.utc
    @joe.remember_token.should_not be_nil
    @joe.remember_token_expires_at.should_not be_nil
    @joe.remember_token_expires_at.between?(before, after).should be_true
  end

  it 'remembers me until one week' do
    time = 1.week.from_now.utc
    @joe.remember_me_until time
    @joe.remember_token.should_not be_nil
    @joe.remember_token_expires_at.should_not be_nil
    @joe.remember_token_expires_at.should == time
  end

  it 'remembers me default two weeks' do
    before = 2.weeks.from_now.utc
    @joe.remember_me
    after = 2.weeks.from_now.utc
    @joe.remember_token.should_not be_nil
    @joe.remember_token_expires_at.should_not be_nil
    @joe.remember_token_expires_at.between?(before, after).should be_true
  end
  
  it "can be reminded of an event" do
    pending("implement remind_of")
    evt = mock_model(:event)
    @joe.remind_of(evt)
  end
  
  it "knows if the reminder has been sent" do
    pending("implement reminder_sent")
    user.remind_of(evt) unless user.reminder_sent(evt)
  end

protected

  def warn_of_db_access
    warn "warning: this test hits the database, maybe use mocks instead?"
  end

  def build_user(options = {})
    returning User.new({ :login => 'user_login',
                         :email => 'user@example.com',
                         :password => 'some_password',
                         :password_confirmation => 'some_password'
                       }.merge(options)) do |u|
      u.valid? # called for side-effects of setting obj.errors
    end
  end
end

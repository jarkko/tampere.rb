require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead.
# Then, you can remove it from this and the functional test.
include AuthenticatedTestHelper

describe User do
  before(:each) do
    @bob_password = 'mypass'
    @bob = build_user(:login => 'bob',
                      :password => @bob_password,
                      :password_confirmation => @bob_password)
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
    @bob.update_attributes(:password => 'new password',
                           :password_confirmation => 'new password')
    User.authenticate('bob', 'new password').should == @bob
  end

  it 'does not rehash password when authenticating' do
    warn "hits database, use mocks/stubs instead"
    @bob.update_attributes(:login => 'bob2')
    User.authenticate('bob2', @bob_password).should == @bob
  end

  it 'authenticates user' do
    User.should_receive(:find_by_login).with('bob').and_return(@bob)
    warn "hits database, use mocks/stubs instead"
    @bob.save!
    User.authenticate('bob', @bob_password).should == @bob
  end

  it 'sets remember token' do
    @bob.remember_me
    @bob.remember_token.should_not be_nil
    @bob.remember_token_expires_at.should_not be_nil
  end

  it 'unsets remember token' do
    @bob.remember_me
    @bob.remember_token.should_not be_nil
    @bob.forget_me
    @bob.remember_token.should be_nil
  end

  it 'remembers me for one week' do
    before = 1.week.from_now.utc
    @bob.remember_me_for 1.week
    after = 1.week.from_now.utc
    @bob.remember_token.should_not be_nil
    @bob.remember_token_expires_at.should_not be_nil
    @bob.remember_token_expires_at.between?(before, after).should be_true
  end

  it 'remembers me until one week' do
    time = 1.week.from_now.utc
    @bob.remember_me_until time
    @bob.remember_token.should_not be_nil
    @bob.remember_token_expires_at.should_not be_nil
    @bob.remember_token_expires_at.should == time
  end

  it 'remembers me default two weeks' do
    before = 2.weeks.from_now.utc
    @bob.remember_me
    after = 2.weeks.from_now.utc
    @bob.remember_token.should_not be_nil
    @bob.remember_token_expires_at.should_not be_nil
    @bob.remember_token_expires_at.between?(before, after).should be_true
  end

protected
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

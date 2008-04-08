require File.dirname(__FILE__) + '/../spec_helper'

# Be sure to include AuthenticatedTestHelper in spec/spec_helper.rb instead
# Then, you can remove it from this and the units test.
include AuthenticatedTestHelper

describe SessionsController do
  fixtures :users

  it 'logins and redirects' do
    #user = User.new(default_user_attributes)
    #User.stub!(:authenticate).and_return(user)
    create_session
    session[:user_id].should_not be_nil
    response.should be_redirect
  end

  it 'fails login and does not redirect' do
    create_session(:login => 'bob', :password => 'badpass')
    session[:user_id].should be_nil
    response.should be_redirect
  end

  it 'logs out' do
    login_as :bob
    get :destroy
    session[:user_id].should be_nil
    response.should be_redirect
  end

  it 'remembers me' do
    post :create, :login => 'bob', :password => 'test', :remember_me => "1"
    response.cookies["auth_token"].should_not be_nil
  end

  # it 'does not remember me' do
  #     post :create, :login => 'bob', :password => 'test', :remember_me => "0"
  #     response.cookies["auth_token"].should be_nil
  # end

  it 'deletes token on logout' do
    login_as :bob
    get :destroy
    response.cookies["auth_token"].should == []
  end

  it 'logs in with cookie' do
    users(:bob).remember_me
    request.cookies["auth_token"] = cookie_for(:bob)
    get :new
    controller.send(:logged_in?).should be_true
  end

  it 'fails expired cookie login' do
    users(:bob).remember_me
    users(:bob).update_attribute :remember_token_expires_at, 5.minutes.ago
    request.cookies["auth_token"] = cookie_for(:bob)
    get :new
    controller.send(:logged_in?).should_not be_true
  end

  it 'fails cookie login' do
    users(:bob).remember_me
    request.cookies["auth_token"] = auth_token('invalid_auth_token')
    get :new
    controller.send(:logged_in?).should_not be_true
  end

  protected

  def create_session(opts={ })
    post :create, default_user_attributes.merge(opts)
  end

  def default_user_attributes
    { :login => 'bob',
      :password => 'test' }
  end

  def auth_token(token)
    CGI::Cookie.new('name' => 'auth_token', 'value' => token)
  end

  def cookie_for(user)
    auth_token users(user).remember_token
  end
end

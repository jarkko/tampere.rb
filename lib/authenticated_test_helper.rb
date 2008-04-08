module AuthenticatedTestHelper
  # Sets the current user in the session from the user fixtures.
  def login_as(user)
    @request.session[:user_id] = user ? users(user).id : nil
  end

  def authorize_as(user)
    @request.env["HTTP_AUTHORIZATION"] = user ? ActionController::HttpAuthentication::Basic.encode_credentials(users(user).login, 'test') : nil
  end

  # my additions

  def fake_login(uid)
    user = mock('user', :id => uid)
    User.stub!(:find_by_id).and_return(user)
    @request.session[:user_id] = uid ? uid : nil
  end
end

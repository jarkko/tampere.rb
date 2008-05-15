class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # TODO: authenticated users can remove other users
  before_filter :login_required, :only => [:create, :index]

  # render new.rhtml
  def new
  end

  def index
  end
  
  def create
    cookies.delete :auth_token
    # protects against session fixation attacks, wreaks havoc with 
    # request forgery protection.
    # uncomment at your own risk
    # reset_session
    @user = User.new(params[:user])
    if @user.save
      self.current_user = @user
      redirect_back_or_default('/')
      flash[:notice] = "Rekisteröityminen onnistui"
    else
      render :action => 'new'
    end
  end
end

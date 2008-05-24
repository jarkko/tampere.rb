class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  # TODO: authenticated users can remove other users
  before_filter :login_required, :only => [:index, :destroy]

  # render new.rhtml
  def new
  end

  def index
    @users = User.find(:all)
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
  
  def destroy
    # TODO: too complex for controller
    current_user_id = current_user.id
    u = User.find params[:id] 
    u.destroy if current_user.admin? || current_user_id == u.id

    return_path = users_path
    
    if current_user_id == params[:id]
      reset_session
      return_path = events_path
    end
    
    respond_to { |format|
      format.html { redirect_to return_path }
      format.xml  { head :ok }
    }
  end
end

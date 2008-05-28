class UsersController < ApplicationController
  # Be sure to include AuthenticationSystem in Application Controller instead
  include AuthenticatedSystem

  before_filter :login_required, :only => [:index, :destroy]

  def new
  end

  def edit
    @user = User.find(params[:id])
  end

  def update
    @user = User.find(params[:id])
    return unless @user.id == current_user.id # only current user can edit

    logger.debug(@user.inspect)
    url = params[:user]['web_page']
    url = 'http://' + url unless url =~ /^http:/
    @user.web_page = url
    @user.email = params[:user]['email']
    if @user.save
      respond_to do |format|
        format.html { redirect_to(@user) }
      end
    end
  end

  def show
    @user = User.find params[:id]
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

# This controller handles the login/logout function of the site.
class SessionsController < ApplicationController
  DEFAULT_URL = '/events'

  # render new.rhtml
  def new
  end

  def create
    self.current_user = User.authenticate(params[:login], params[:password])
    if logged_in?
      if params[:remember_me] == "1"
        self.current_user.remember_me
        cookies[:auth_token] = { :value => self.current_user.remember_token , :expires => self.current_user.remember_token_expires_at }
      end
      redirect_back_or_default(DEFAULT_URL)
      flash[:notice] = "Sisäänkirjautuminen onnistui"
    else
      flash[:error] = "Väärä käyttäjätunnus tai salasana"
      render :action => 'new'
    end
  end

  def destroy
    self.current_user.forget_me if logged_in?
    cookies.delete :auth_token
    reset_session
    flash[:notice] = "Olet kirjautunut pois palvelusta."
    redirect_back_or_default(DEFAULT_URL)
  end
end

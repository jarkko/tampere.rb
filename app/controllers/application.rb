# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  filter_parameter_logging :password
  include AuthenticatedSystem

  helper :all # include all helpers, all the time

  layout "site"

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery # :secret => '977b7fdc480cc59a1d50a76ae5e68df6'
  
  CalendarDateSelect.format = :finnish

  # override default access_denied method
  def access_denied
    flash[:notice] = 'Ole hyvä ja kirjaudu sisään tai rekisteröidy'
    redirect_to events_path
  end
end

class EventsController < ApplicationController
  before_filter :login_required, :only => [:new,
    :edit,
    :create,
    :update,
    :destroy]

  # GET /events
  # GET /events.xml
  def index
    @events = Event.find_upcoming(5).reverse
    @title = 'Tulevat tapahtumat'
    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => events }
    end
  end

  # GET /events/archived
  # GET /events/archived.xml
  def archived
    now = Time.now
    @title = 'Menneet tapahtumat'
    @events = Event.find_recent(100).select { |e| e.date < now }

    respond_to do |format|
      format.html { render :action => :index }
      format.xml  { render :xml => events }
    end
  end

  # GET /events/1
  # GET /events/1.xml
  def show
    @event = Event.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/new
  # GET /events/new.xml
  def new
    @event = Event.new_default

    respond_to do |format|
      format.html # new.html.erb
      format.xml  { render :xml => @event }
    end
  end

  # GET /events/1/edit
  def edit
    @event = Event.find(params[:id])
  end

  # POST /events
  # POST /events.xml
  def create
    # TODO: this is a bit too hackish, and deals too much with handling attributes
    # -> move to model

    attrs = params[:event]
    attrs['location'] = Location.find_by_id_or_build_by_name(attrs['location'],
                                                             attrs['location_id'])
    attrs['date'] = EuropeanDate.to_iso(attrs['date'])
    # attr location already contains loc, so we omit loc_id
        @event = Event.new(attrs.reject { |k,v| k == 'location_id' })

    respond_to do |format|
      if @event.save
        flash[:notice] = 'Tapahtuma luotu.'
        format.html { redirect_to events_path }
        # format.xml  { render :xml => ... }
      else
        format.html { render :action => "new" }
        format.xml  { render :xml => @event.errors,
                             :status => :unprocessable_entity }
      end
    end
  end

  # PUT /events/1
  # PUT /events/1.xml
  def update
    @event = Event.find(params[:id])

    respond_to do |format|
      # TODO: belongs to Event#update_from_form?
      params[:event]['date'] = EuropeanDate.to_iso(params[:event]['date'])
      begin
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Tapahtuma päivitetty.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
      end
      rescue ActiveRecord::StaleObjectError => e
        flash[:notice] = 'Valitettavasti tapahtumaa muokkasi jo joku
    toinen. Yritä myöhemmin uudestaan.'
      end
    end
  end

  # DELETE /events/1
  # DELETE /events/1.xml
  def destroy
    @event = Event.find(params[:id])
    @event.destroy

    respond_to do |format|
      format.html { redirect_to(events_url) }
      format.xml  { head :ok }
    end
  end

  def register
    Event.register_user(params[:id], params[:user_id])
    redirect_to events_path
  end

  private
#   def set_location_param(hsh)
#     loc_name = hsh['location']
#     hsh['location'] =
#       loc_name.blank? ? Location.find(hsh['location_id']) :
#                         Location.new(:title => loc_name)
#     hsh.delete('location_id')
#   end
end

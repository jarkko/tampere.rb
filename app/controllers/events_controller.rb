class EventsController < ApplicationController
  before_filter :login_required, :only => [:new,
    :edit,
    :create,
    :update,
    :destroy]

  # GET /events
  # GET /events.xml
  def index
    events = Event.find_recent(5)
    now = Time.now
    @coming_events, @past_events = events.partition { |e| e.date >= now }

    respond_to do |format|
      format.html # index.html.erb
      format.xml  { render :xml => events }
    end
  end

  # GET /events/archived
  # GET /events/archived.xml
  def archived
    events = Event.find_recent(100)
    now = Time.now
    @coming_events = []
    @past_events = events.select { |e| e.date < now }

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
    attrs = params[:event]
    attrs['location'] = Location.find_by_id_or_build_by_name(attrs['location'],
                                                             attrs['location_id'])

    # attr location already contains loc, so we omit loc_id
    # TODO: even better, move to model
    @event = Event.new(attrs.reject { |k,v| k == 'location_id' })

    # TODO: move this elsewhere.. besides, it should be done automatically
    # for all date parsing
    @event.date = Date.strptime(params[:event]['date'], '%d.%m.%Y')

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
      if @event.update_attributes(params[:event])
        flash[:notice] = 'Tapahtuma päivitetty.'
        format.html { redirect_to(@event) }
        format.xml  { head :ok }
      else
        format.html { render :action => "edit" }
        format.xml  { render :xml => @event.errors, :status => :unprocessable_entity }
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

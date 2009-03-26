class EventsController < ApplicationController
  before_filter :load_event, :only => [:show, :edit, :update, :destroy]
  before_filter :find_location

  def new
    @event = @location.events.build
    @categories = Category.first_level.for_event(:order => :title)
  end
  
  def create
    @event = @location.events.build(params[:event])
    if @event.save
      @user.event_logs.create(:action => "create_event", :content => @event.id, :user_agent => request.env["HTTP_USER_AGENT"], :ip_address => request.env["X-Real-IP"])
      redirect_to event_permalink(@event)
    else
      @categories = Category.first_level.for_event(:order => :title)
      render :new
    end
  end
  
  def show
  end
  
  def edit
  end
  
  def update
    if @event.update_attributes(params[:event])
      flash[:notice] = "Event has been updated successfully."
      @user.event_logs.create(:action => "update_event", :content => @event.id, :user_agent => request.env["HTTP_USER_AGENT"], :ip_address => request.env["X-Real-IP"])
      redirect_to event_permalink(@event)
    else
      render :edit
    end
  end

  private
  
  def find_location
    if params[:location_id]
      @location = Location.find(params[:location_id])
    else
      @location = @event.location
    end
  end
  
  def load_event
    @event = if params[:id][/^[0-9]+$/]
        Event.find(params[:id])
      else
        Event.find(params[:id].split(/-/,2)[0])
      end
    redirect_to event_permalink(@event), :status => 301 if params[:id][/^[0-9]+$/] and params[:action] == "show"
  end
end
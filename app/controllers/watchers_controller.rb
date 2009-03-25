class WatchersController < ApplicationController
  before_filter :find_event

  def create
    if logged_in?
      if @event.watcher_ids.include? @user.id
        @event.watchers.delete(@user)
      else
        @event.watchers << @user
      end
      respond_to do |wants|
        wants.js
      end
    else
      render :text => "You must be logged in first!", :status => 500 unless logged_in?
    end
  end

  private
  
  def find_event
    @event = Event.find(params[:event_id])
  end
end
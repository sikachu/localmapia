class TagsController < ApplicationController
  before_filter :load_taggable
  
  def create
    Tag.batch_create(params[:tag], @taggable)
    flash[:notice] = "Your tags has been added"
    redirect_to params[:event_id] ? event_permalink(@taggable) : location_permalink(@taggable)
  end
  
  private
  
  def load_taggable
    @taggable = if params[:event_id]
        Event.find(params[:event_id])
      else
        Location.find(params[:location_id])
      end
  end
end
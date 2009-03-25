class TagsController < ApplicationController
  before_filter :load_location
  
  def create
    Tag.batch_create(params[:tag], @location)
    flash[:notice] = "Your tags has been added"
    redirect_to location_permalink(@location)
  end
  
  private
  
  def load_location
    @location = Location.find(params[:location_id])
  end
end
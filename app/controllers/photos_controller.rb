class PhotosController < ApplicationController
  before_filter :check_login, :find_attachable

  def create
    @photo = @attachable.photos.build(params[:photo].merge(:album_type => "flickr"))
    @photo.user = @user
    
    respond_to do |wants|
      wants.js do
        unless @photo.save
          render :text => "alert('URL you entered #{@photo.errors.on(:original_url)}'); $('#photo_original_url').val('');"
        end
      end
    end
  end

  private
  def find_attachable
    @attachable = if params[:event_id]
        Event.find(params[:event_id])
      else
        Location.find(params[:location_id])
      end
  end
end
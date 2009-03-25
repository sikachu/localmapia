class FeedbacksController < ApplicationController
  before_filter :find_location

  def create
    unless logged_in?
      flash[:error] = "You need to be logged in first before you can post a feedback."
    else
      @feedback = @location.feedbacks.build(params[:feedback].merge({:user_id => @user.id}))
      if @feedback.save
        flash[:notice] = "Your feedback has been added"
      end
    end
    redirect_to location_permalink(@location)
  end

  private
  def find_location
    @location = Location.find(params[:location_id])
  end
end
class FeedbacksController < ApplicationController
  before_filter :load_commentable

  def create
    unless logged_in?
      flash[:error] = "You need to be logged in first before you can post a feedback."
    else
      @feedback = @commentable.feedbacks.build(params[:feedback].merge({:user_id => @user.id}))
      if @feedback.save
        flash[:notice] = "Your feedback has been added"
      end
    end
    redirect_to params[:event_id] ? event_permalink(@commentable) : location_permalink(@commentable)
  end

  private
  
  def load_commentable
    @commentable = if params[:event_id]
        Event.find(params[:event_id])
      else
        Location.find(params[:location_id])
      end
  end
end
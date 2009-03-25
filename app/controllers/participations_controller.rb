class ParticipationsController < ApplicationController
  before_filter :find_event

  def create
    if logged_in?
      if @participation = @event.participations.find_by_user_id(@user.id)
        @participation.destroy
      else
        @event.participations.create(:user_id => @user.id)
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
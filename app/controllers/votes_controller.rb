class VotesController < ApplicationController
  before_filter :load_votable

  def create
    if logged_in?
      @votable.votes.create(:user_id => @user.id, :score => params[:score].to_f / 10)
      respond_to do |wants|
        wants.js
      end
    else
      render :text => "You must be logged in first!", :status => 500 unless logged_in?
    end
  end

  private
  
  def load_votable
    @votable = if params[:event_id]
        Event.find(params[:event_id])
      else
        Location.find(params[:location_id])
      end
  end
end
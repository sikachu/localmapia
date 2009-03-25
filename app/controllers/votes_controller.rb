class VotesController < ApplicationController
  before_filter :find_location

  def create
    if logged_in?
      @location.votes.create(:user_id => @user.id, :score => params[:score].to_f / 10)
      respond_to do |wants|
        wants.js
      end
    else
      render :text => "You must be logged in first!", :status => 500 unless logged_in?
    end
  end

  private
  def find_location
    @location = Location.find(params[:location_id])
  end
end
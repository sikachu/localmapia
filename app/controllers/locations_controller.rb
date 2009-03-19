class LocationsController < ApplicationController
  before_filter :load_location, :only => [:step1, :step2]
  
  def index
  end
  
  def new
    redirect_to :step1_new_location
  end

  def step1
    @location = Location.new(session[:location])
  end

  def step2
    @location = Location.new(session[:location])
  end

  def create
  end

  def show
  end

  def edit
  end

  def update
  end

  def destroy
  end
  
  private
  
  def load_location
    unless logged_in?
      flash[:notice] = "You're just one step away from adding new location. Please login or register below:"
      redirect_to login_path
    end
    @location = Location.new(session[:location])
  end

end

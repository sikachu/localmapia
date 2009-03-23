class LocationsController < ApplicationController
  before_filter :load_location, :only => [:step1, :step2]
  
  def index
  end
  
  def new
    redirect_to :step1_new_location
  end

  def step1
    @location = Location.new
  end

  def step2
    redirect_to :action => "step1" unless session[:location]
    @location = session[:location]
    @first_level_categories = Category.first_level.for_location
    @second_level_categories = Category.second_level(@first_level_categories.first.id).for_location rescue []
  end

  def create
    if params[:location][:latlng].present? # From step 1
      session[:location] = Location.new(params[:location])
      redirect_to :action => "step2"
    else
      session[:location].attributes = params[:location]
      unless session[:location].save
        redirect_to :action => "step2"
      end
    end
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
  end

end

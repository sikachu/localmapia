class LocationsController < ApplicationController
  before_filter :check_for_login, :only => [:step1, :step2]
  before_filter :load_location, :only => [:show, :edit, :update, :destroy]
  
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
      session[:location] = Location.new(params[:location].merge(:user_id => @user.id))
      redirect_to :action => "step2"
    else
      session[:location].attributes = params[:location]
      if session[:location].save
        redirect_to location_permalink(session[:location])
      else
        redirect_to :action => "step2"
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    if @location.update_attributes(params[:location])
      flash[:notice] = "Location's has been updated successfully."
      redirect_to location_permalink(session[:location])
    else
      render :edit
    end
  end

  def destroy
  end
  
  def categories
    @categories = if params[:parent_id].blank?
        Category.for_location.first_level
      else
        Category.for_location.second_level(params[:parent_id])
      end
    render :layout => false
  end
  
  private
  
  def check_for_login
    unless logged_in?
      flash[:notice] = "You're just one step away from adding new location. Please login or register below:"
      redirect_to login_path
    end
  end
  
  def load_location
    @location = if params[:id][/^[0-9]+$/]
        Location.find(params[:id])
      else
        Location.find_by_permalink!(params[:id])
      end
    redirect_to location_permalink(@location), :status => 301 if params[:id][/^[0-9]+$/] and params[:action] == "show"
  end

end

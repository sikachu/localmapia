# Filters added to this controller apply to all controllers in the application.
# Likewise, all the methods added will be available for all controllers.

class ApplicationController < ActionController::Base
  helper :all # include all helpers, all the time
  
  include Authentication::Helpers

  # See ActionController::RequestForgeryProtection for details
  # Uncomment the :secret if you're not using the cookie session store
  protect_from_forgery
  
  # See ActionController::Base for details 
  # Uncomment this to filter the contents of submitted sensitive data parameters
  # from your application log (in this case, all fields with names like "password"). 
  filter_parameter_logging :password, :password_confirmation
  
  protected
  
  helper_method :location_permalink, :event_permalink, :category_permalink
  def location_permalink(location)
    "/locations/#{location.permalink}"
  end
  
  def event_permalink(event)
    "/events/#{event.permalink}"
  end
  
  def category_permalink(category)
    "/#{category.category_type}s/in/#{category.parent.title.downcase.gsub(/ /, '-')+"/" if category.parent}#{category.title.downcase.gsub(/ /, '-')}"
  end
end

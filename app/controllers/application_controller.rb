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
  
  helper_method :location_permalink, :event_permalink, :category_permalink, :object_permalink
  def object_permalink(object)
    object.class == Location ? location_permalink(object) : event_permalink(object)
  end
  
  def location_permalink(location)
    URI.escape "/locations/#{location.permalink}"
  end
  
  def event_permalink(event)
    URI.escape "/events/#{event.permalink}"
  end
  
  def category_permalink(category)
    URI.escape "/#{category.category_type}s/in/#{category.parent.permalink+"/" if category.parent}#{category.permalink}"
  end
  
  helper_method :moderator?, :admin?
  def moderator?
    logged_in? and @user.moderator?
  end
  
  def admin?
    logged_in? and @user.admin?
  end
end

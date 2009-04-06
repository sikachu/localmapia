module LocationsHelper
  def rating_stars(stars)
    output = "<span class=\"stars\">"
    5.times do
      if stars >= 1
        output << "<span class=\"fullstar\"></span>"
      elsif stars >= 0
        output << "<span class=\"halfstar\"></span>"
      else
        output << "<span class=\"blankstar\"></span>"
      end
      stars -= 1
    end
    "#{output}</span>"
  end
  
  def buttons_for_description
    output = ""
    output += button_to_function("Edit", "window.location.href='#{@event ? edit_event_path(@event) : edit_location_path(@location)}'", :class => "small-edit-button") if logged_in?
    #output += " " + button_to_function("Revert", "", :class => "small-revert-button") if moderator?
    output
  end
  
  def buttons_for_tags
    button_to_function("Add","$('#new_tag>.displaynone').slideToggle();", :class => "small-add-button") if logged_in?
  end
  
  def buttons_for_photos
    button_to_function("Add","$('#new_photo>.displaynone').slideToggle();", :class => "small-add-button") if logged_in?
  end
  
  def buttons_for_events
    button_to_function("Add","window.location='#{new_location_event_path(@location)}'", :class => "small-add-button") if logged_in?
  end
end

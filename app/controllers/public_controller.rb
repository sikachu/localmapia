class PublicController < ApplicationController
  def index
    @featured_places = Location.featured
    @featured_events = Event.featured.active
    @recently_added = Location.recently_added
    @recently_updated = Location.recently_updated
    @top_contributers = EventLog.top_contributors
  end
end

ActionController::Routing::Routes.draw do |map|
  map.resource :session, :only => [:new, :create, :destroy]
  map.resources :locations, :new => [:step1, :step2], :collection => { :categories => :get } do |location|
    location.resources :events, :shallow => true do |event|
      event.resources :feedbacks, :shallow => false
      event.resources :photos, :shallow => false
      event.resources :tags, :shallow => false
      event.resources :votes, :shallow => false
      event.resources :watchers, :shallow => false
      event.resources :participations, :shallow => false
      event.resources :mails, :shallow => false
    end
    location.resources :feedbacks
    location.resources :photos
    location.resources :tags
    location.resources :votes
    location.resources :mails
  end
  map.resource :account, :path_names => { :new => 'register' }, :member => { :status => :get }
  map.activate "account/activate/:id", :controller => "accounts", :action => "activate"
  map.resources :searches
  map.resources :categories
  map.connect ":object_type/in/:parent/:id", :controller => "categories", :action => "show", :object_type => /events|locations/
  map.resources :tags
  map.resources :reports
  map.browse "browse", :controller => "categories"
  
  map.login "login", :controller => "sessions", :action => "new"
  map.logout "logout", :controller => "sessions", :action => "destroy"

  map.root :controller => "public"
end

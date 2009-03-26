ActionController::Routing::Routes.draw do |map|
  # The priority is based upon order of creation: first created -> highest priority.

  # Sample of regular route:
  #   map.connect 'products/:id', :controller => 'catalog', :action => 'view'
  # Keep in mind you can assign values other than :controller and :action

  # Sample of named route:
  #   map.purchase 'products/:id/purchase', :controller => 'catalog', :action => 'purchase'
  # This route can be invoked with purchase_url(:id => product.id)

  # Sample resource route (maps HTTP verbs to controller actions automatically):
  #   map.resources :products
  map.resource :session, :only => [:new, :create, :destroy]
  map.resources :locations, :new => [:step1, :step2], :collection => { :categories => :get } do |location|
    location.resources :events, :shallow => true do |event|
      event.resources :feedbacks, :shallow => false
      event.resources :photos, :shallow => false
      event.resources :tags, :shallow => false
      event.resources :votes, :shallow => false
      event.resources :watchers, :shallow => false
      event.resources :participations, :shallow => false
    end
    location.resources :feedbacks
    location.resources :photos
    location.resources :tags
    location.resources :votes
  end
  map.resource :account, :path_names => { :new => 'register' }, :member => { :status => :get }
  map.activate "account/activate/:id", :controller => "accounts", :action => "activate"
  map.resources :searches
  
  map.login "login", :controller => "sessions", :action => "new"
  map.logout "logout", :controller => "sessions", :action => "destroy"

  # Sample resource route with options:
  #   map.resources :products, :member => { :short => :get, :toggle => :post }, :collection => { :sold => :get }

  # Sample resource route with sub-resources:
  #   map.resources :products, :has_many => [ :comments, :sales ], :has_one => :seller
  
  # Sample resource route with more complex sub-resources
  #   map.resources :products do |products|
  #     products.resources :comments
  #     products.resources :sales, :collection => { :recent => :get }
  #   end

  # Sample resource route within a namespace:
  #   map.namespace :admin do |admin|
  #     # Directs /admin/products/* to Admin::ProductsController (app/controllers/admin/products_controller.rb)
  #     admin.resources :products
  #   end

  # You can have the root of your site routed with map.root -- just remember to delete public/index.html.
  map.root :controller => "public"

  # See how all your routes lay out with "rake routes"

  # Install the default routes as the lowest priority.
  # Note: These default routes make all actions in every controller accessible via GET requests. You should
  # consider removing the them or commenting them out if you're using named routes and resources.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

ActionController::Routing::Routes.draw do |map|
  map.resources :games

  map.home '', :controller => 'games', :action => 'new'

  # Install the default routes as the lowest priority.
  map.connect ':controller/:action/:id'
  map.connect ':controller/:action/:id.:format'
end

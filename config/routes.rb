ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'books', :action => 'index'
  map.resources :books
  map.resources :authors
  map.resources :searches
end

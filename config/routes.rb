ActionController::Routing::Routes.draw do |map|
  map.root :controller => 'dashboard', :action => 'index'

  map.widget '/widget', :controller => 'dashboard', :action => 'index', :format => 'widget'

  map.resources :users
  map.resource :session
  
  map.feed '/feed.atom', :controller => 'dashboard', :action => 'feed', :format => 'atom'

  map.resources :books, { :member => { :notify => :post, :reload => :put } } do |books|
    books.resources :loans
  end
  map.resources :authors
  map.resources :publishers
  map.resources :searches
  map.resources :loans

  map.logout '/logout', :controller => 'session', :action => 'destroy'
end

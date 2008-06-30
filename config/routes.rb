ActionController::Routing::Routes.draw do |map|
  map.logout '/logout', :controller => 'sessions', :action => 'destroy'
  map.login '/login', :controller => 'sessions', :action => 'new'
  map.register '/register', :controller => 'users', :action => 'create'
  map.signup '/signup', :controller => 'users', :action => 'new'
  map.resources :users
  map.resource :session
  
  map.connect '/feed.:format', :controller => 'dashboard', :action => 'index'

  map.root :controller => 'dashboard', :action => 'index'
  map.resources :books, { :member => { :notify => :post } } do |books|
    books.resources :loans
  end
  map.resources :authors
  map.resources :publishers
  map.resources :searches
  map.resources :loans
end

Rails.application.routes.draw do
  root 'welcome#index'
  get '/login', to: 'sessions#login'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#logout'
  get '/signup', to: 'users#new'
  get '/legislators/:id', to: 'legislators#show'
  post '/upvotes/create', to: 'upvotes#create'

  resources :stances do
    get '/donations', to: 'donations#show'
    post '/donations', to: 'donations#create'
  end

  get '/search', to: 'stances#search'
<<<<<<< Updated upstream
  get '/stances/issues/:select', to: 'stances#select'
=======
  get 'stances/:select', to: 'stances#select'
  get 'stances/:sort', to: 'stances#sort'
>>>>>>> Stashed changes

  resources :users
end

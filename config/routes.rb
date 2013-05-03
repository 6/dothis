Dothis::Application.routes.draw do
  get '/signup' => 'users#new'
  get '/login' => 'sessions#new'
  get '/logout' => 'sessions#destroy'

  resources :users
  resources :tasks
  resources :sessions

  get '/:username' => 'users#show', :as => :profile

  root :to => 'users#index', :constraints => lambda { |request| !request.cookies['auth_token'] }
  root :to => 'tasks#index', :constraints => lambda { |request| !!request.cookies['auth_token'] }
end

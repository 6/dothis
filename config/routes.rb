Dothis::Application.routes.draw do
  get '/signup' => 'users#new'
  get '/login' => 'sessions#new'
  get '/logout' => 'sessions#destroy'

  resources :users
  resources :sessions

  get '/:username' => 'users#show', :as => :profile

  root :to => 'users#index'
end

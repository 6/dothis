Dothis::Application.routes.draw do
  get '/signup' => 'users#new'
  get '/login' => 'sessions#new'
  get '/logout' => 'sessions#destroy'

  resources :users
  resources :sessions

  get '/:username' => 'users#show'

  root :to => 'users#index'
end

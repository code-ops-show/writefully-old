Writefully::Engine.routes.draw do
  resources :sites
  resources :authorships
  resource  :hook, only: [:create]

  get '/signin',     to: 'sessions#new'
  get '/owner/auth', to: 'sessions#create'
  get '/signout',    to: 'sessions#destroy'

  root to: 'sites#index'
end

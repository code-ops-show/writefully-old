Writefully::Engine.routes.draw do
  resources :sites
  resources :authorships
  resource  :setup, only: [:show]
  resource  :hook, only: [:create]

  root to: 'sites#index'
end

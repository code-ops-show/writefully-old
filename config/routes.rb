Writefully::Engine.routes.draw do
  resources :sites
  resource  :setup, only: [:show]
  resource  :hook, only: [:create]

  root to: 'sites#index'
end

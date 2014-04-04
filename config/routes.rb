Writefully::Engine.routes.draw do
  resources :sites
  resource  :hook, only: [:create]
end

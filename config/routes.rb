Writefully::Engine.routes.draw do

  resources :sites do 
    get 'tab/:tab', to: 'sites#show', as: :tab, on: :member
    resources :posts, only: [:index, :show]
  end

  resource  :profile,    only: [:edit]
  resource  :authorship, only: [:update]
  resource  :hook, only: [:create]

  get '/signin',     to: 'sessions#new'
  get '/owner/auth', to: 'sessions#create'
  get '/signout',    to: 'sessions#destroy'

  root to: 'sites#index'
end

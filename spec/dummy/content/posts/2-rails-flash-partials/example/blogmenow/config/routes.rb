Blogmenow::Application.routes.draw do
  resources :posts
  
  root to: 'posts#index'
end

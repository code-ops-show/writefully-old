gem 'writefully'

inside app_name do 
  run "bundle install"
  run "bundle binstubs writefully"
end

rake "writefully:install:migrations"

generate :model, "Post", "--skip-migration --parent=writefully/post"

route "root to: 'posts#index'"
route "resources :posts, only: [:index, :show]"
route "mount Writefully::Engine, at: '/writefully'"

generate :controller, "posts"
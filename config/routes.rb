Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, :skip => [:sessions]
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
    get    '/login'   => 'devise/sessions#new',     as: :new_session
    post   '/login'   => 'devise/sessions#create',  as: :user_session
    get '/sign_up' => 'users/registrations#new', as: :new_user_session
  end
  resources :test_modules
  resources :activities
  resources :products
  root 'products#index'

  # nav bar


  get 'profile' => 'profile#show'
  get 'profile/:id' => 'profile#show', as: 'profile_show'
  post 'profile/follow' => 'profile#follow', as: 'profile_follow'
  post 'profile/unfollow' => 'profile#unfollow', as: 'profile_unfollow'
  get 'profile/:id/followers' => 'profile#followers', as: 'profile_followers'
  get 'profile/:id/following' => 'profile#following', as: 'profile_following'
  get 'profile/:id/shared' => 'profile#sharedProducts', as: 'profile_shared_products'
  get 'list/:id' => 'profile#showList', as: 'profile_list'
  get 'settings' => 'profile#settings', as: 'profile_settings'

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  get "api/:user_email/:user_token/profile/:id" => 'profile#show',
      as: 'api_show_profile', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }
  post "api/signin" => "profile#getAuthenticationToken",
      as: 'api_signin', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }
  post "api/signup" => "profile#api_signup",
    as: 'api_signup', :defaults => { :format => 'json' }, :constraints => { :email => /[^\/]+/ }
 
 # mrkt api
 get "mrkt/:user_email/:user_token/getMutualFriendsImages/:friends" => 'profile#getMutualFriendsImages',
   as: 'mrkt_get_friends', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }


 get "mrkt/:user_email/:user_token/getPostDetail/:post_id" => 'posts#getPostDetail',
   as: 'mrkt_get_detail', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }

 get "mrkt/:user_email/:user_token/getYardPosts" => 'posts#getYardPosts',
   as: 'mrkt_get_yardsposts', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }

 get "mrkt/:user_email/:user_token/getPosts" => 'posts#getPosts',
   as: 'mrkt_get_posts', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }

post "mrkt/createPost" => "posts#createPost",
    as: 'mrkt_create_post', :defaults => { :format => 'json' }, :constraints => { :email => /[^\/]+/ } 
# bottom for testing purposes (get instead of post)
 #get "mrkt/:user_email/:user_token/createPost" => 'posts#createPost',
 #  as: 'mrkt_get_posts_get', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }

post "mrkt/sendMessage" => "chats#sendMessage",
    as: 'mrkt_send_message', :defaults => { :format => 'json' }, :constraints => { :email => /[^\/]+/ }

 get "mrkt/:user_email/:user_token/getChats" => 'chats#getChats',
   as: 'mrkt_get_chats', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }

post "mrkt/setLocation" => "profile#setLocation",
    as: 'mrkt_set_location_post', :defaults => { :format => 'json' }, :constraints => { :email => /[^\/]+/ , :latitude =>/[\w+\.-]+/,  :longitude => /[\w+\.-]+/}

 get "mrkt/:user_email/:user_token/setLocation/:latitude/:longitude" => 'profile#setLocation',
   as: 'mrkt_set_location', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }

post "mrkt/likePost" => "posts#likePost",
    as: 'mrkt_like_post', :defaults => { :format => 'json' }, :constraints => { :email => /[^\/]+/ }

post "mrkt/dislikePost" => "posts#dislikePost",
    as: 'mrkt_dislike_post', :defaults => { :format => 'json' }, :constraints => { :email => /[^\/]+/ }

  
  # The priority is based upon order of creation: first created -> highest priority.
  # See how all your routes lay out with "rake routes".

  # You can have the root of your site routed with "root"
  # root 'welcome#index'

  # Example of regular route:
  #   get 'products/:id' => 'catalog#view'

  # Example of named route that can be invoked with purchase_url(id: product.id)
  #   get 'products/:id/purchase' => 'catalog#purchase', as: :purchase

  # Example resource route (maps HTTP verbs to controller actions automatically):
  #   resources :products

  # Example resource route with options:
  #   resources :products do
  #     member do
  #       get 'short'
  #       post 'toggle'
  #     end
  #
  #     collection do
  #       get 'sold'
  #     end
  #   end

  # Example resource route with sub-resources:
  #   resources :products do
  #     resources :comments, :sales
  #     resource :seller
  #   end

  # Example resource route with more complex sub-resources:
  #   resources :products do
  #     resources :comments
  #     resources :sales do
  #       get 'recent', on: :collection
  #     end
  #   end

  # Example resource route with concerns:
  #   concern :toggleable do
  #     post 'toggle'
  #   end
  #   resources :posts, concerns: :toggleable
  #   resources :photos, concerns: :toggleable

  # Example resource route within a namespace:
  #   namespace :admin do
  #     # Directs /admin/products/* to Admin::ProductsController
  #     # (app/controllers/admin/products_controller.rb)
  #     resources :products
  #   end
end

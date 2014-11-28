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
  get 'feed' => 'products#socialFeed', as: 'social_feed'
  get 'moreSocial' => 'products#moreSocialFeed', as: 'more_social_feed'

  # nav bar
  get 'discover' => 'products#discover', as: 'discover'

  patch 'users/update' => 'profile#update', as: 'user_path'

  get 'profile' => 'profile#show'
  get 'profile/:id' => 'profile#show', as: 'profile_show'
  post 'profile/follow' => 'profile#follow', as: 'profile_follow'
  post 'profile/unfollow' => 'profile#unfollow', as: 'profile_unfollow'
  get 'profile/:id/followers' => 'profile#followers', as: 'profile_followers'
  get 'profile/:id/following' => 'profile#following', as: 'profile_following'
  get 'profile/:id/shared' => 'profile#sharedProducts', as: 'profile_shared_products'
  get 'list/:id' => 'profile#showList', as: 'profile_list'
  get 'settings' => 'profile#settings', as: 'profile_settings'

  post 'products/new' => 'products#findImages'
  get '/vigit' => 'products#findImages'
  get '/purchased' => 'products#purchased'
  post '/purchase/receipt' => 'products#purchaseReceipt'

  get 'product/categorize' => 'products#categorizeProduct', as: 'categorize_product'
  post 'product/add' => 'products#saveProduct', as: 'save_product'
  get 'product/showProduct' => 'products#showProductModal', as: 'show_product_modal'
  post 'product/share' => 'products#share', as: 'share_product'
  post 'product/buy' => 'products#buy', as: 'buy_product'
  post 'product/begin' => 'products#displayUrlForm', as: 'product_url_form'
  get 'social/loaded' => 'products#socialFeedLoaded', as: 'social_feed_loaded'
  post 'list/new' => 'list#displayListForm', as: 'list_form'
  post 'list/create' => 'list#create', as: 'list_create'
  post 'list/addProduct' => 'list#addProductToList', as: 'list_add_product'
  get 'addProduct' => 'list#addProductToList', as: 'add_product'



  get 'rankings' => 'ranking#index', as: 'ranking'

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  # viglets woo
  get 'viglets' => 'products#viglets', as: 'viglets'

  # admin stuff
  get 'admin' => 'admin#index', as: 'admin'
  get 'admin/login' => 'admin#login', as: 'admin_login'
  get 'admin/purchases' => 'admin#purchaseConfirmation', as: 'purchase_confirmation'
  get 'receipt/:id' => 'admin#receipt', as: 'receipt'
  post 'admin/confirm' => 'admin#confirmed', as: "confirm_purchase"
  #signup process
  get 'step1' => 'profile#step_one', as: 'signup_step_one'
  patch 'step1complete' => 'profile#step_one_complete', as: 'signup_step_one_complete_patch'
  get 'step1complete' => 'profile#step_one_complete', as: 'signup_step_one_complete'
  get 'step2' => 'profile#step_two', as: 'signup_step_two'
  post 'step2complete' => 'profile#step_two_complete', as: 'signup_step_two_complete'
  get 'step3' => 'profile#step_three', as: 'signup_step_three'
  post 'step3complete' => 'profile#step_three_complete', as: 'signup_step_three_complete'

  # api v1
  get "api/:user_email/:user_token/product/:product_id/:offset" => 'products#showProductModal',
   as: 'api_show_product', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }
  get "api/:user_email/:user_token/feed/:page/:product_page" => 'products#socialFeed',
   as: 'api_social_feed', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }

  get "api/:user_email/:user_token/product_feed/:page" => 'products#product_feed',
   as: 'api_product_feed', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }
 
  get "api/:user_email/:user_token/discover/:page" => 'products#discover',
    as: 'api_discover_feed', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }
  get "api/:user_email/:user_token/profile/:id" => 'profile#show',
      as: 'api_show_profile', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }
  post "api/signin" => "profile#getAuthenticationToken",
      as: 'api_signin', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }
  post "api/signup" => "profile#api_signup",
    as: 'api_signup', :defaults => { :format => 'json' }, :constraints => { :email => /[^\/]+/ }
  
  # api v1 - add a product flow
  post "api/findImages" => "products#findImages",
    as: 'api_find_images', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }
  post "api/categories" => "products#categorizeProduct",
    as: 'api_categories', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }
  post "api/saveProduct" => "products#saveProduct",
    as: 'api_save_product', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }
  
  # api v1 - save product flow
  get "api/:user_email/:user_token/share/:product_id" => "products#share", 
    as: 'api_share_product', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }
  get "api/:user_email/:user_token/share/:product_id/:list_id" => "list#addProductToList", 
    as: 'api_share_product_list', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }

  get "api/:user_email/:user_token/list/:id/:page" => "profile#showList", 
    as: 'api_list_products', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }
  
   # share product 
  get 'api/:user_email/:user_token/product/share' => 'products#share', as: 'get_share_product', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }


 # api v1 - un/follow
  get "api/:user_email/:user_token/follow/:user_to_follow" => "profile#follow", 
   as: 'api_follow', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }
  get "api/:user_email/:user_token/unfollow/:user_to_unfollow" => "profile#unfollow", 
  as: 'api_unfollow', :defaults => { :format => 'json' }, :constraints => { :user_email => /[^\/]+/ }
 
  #theme testing
  get 'test_module/colorz' => 'test_modules#colorz'
  get 'test_module/escape' => 'test_modules#escape'
  get 'test_module/flat' => 'test_modules#flat'
  get 'test_module/caphov' => 'test_modules#caphov'


  
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

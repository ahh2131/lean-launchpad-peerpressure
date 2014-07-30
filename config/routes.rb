Rails.application.routes.draw do
  devise_for :users, :controllers => { :omniauth_callbacks => "users/omniauth_callbacks" }, :skip => [:sessions]
  devise_scope :user do
    get 'sign_out', :to => 'devise/sessions#destroy', :as => :destroy_user_session
    get    '/login'   => 'users/sessions#new',     as: :new_user_session
    post   '/login'   => 'devise/sessions#create',  as: :user_session
  end
  resources :test_modules
  resources :activities
  resources :products
  root 'products#index'
  get 'feed' => 'products#socialFeed', as: 'social_feed'
  get 'moreSocial' => 'products#moreSocialFeed', as: 'more_social_feed'

  patch 'users/update' => 'profile#update', as: 'user_path'

  get 'profile' => 'profile#show'
  get 'profile/:id' => 'profile#show'
  post 'profile/follow' => 'profile#follow', as: 'profile_follow'
  post 'profile/unfollow' => 'profile#unfollow', as: 'profile_unfollow'
  get 'settings' => 'profile#settings', as: 'profile_settings'

  post 'products/new' => 'products#findImages'
  get '/vigit' => 'products#findImages'
  get '/purchased' => 'products#purchased'
  post '/purchase/receipt' => 'products#purchaseReceipt'

  get 'product/add' => 'products#saveProduct', as: 'save_product'
  post 'product/share' => 'products#share', as: 'share_product'
  post 'product/buy' => 'products#buy', as: 'buy_product'
  post 'product/begin' => 'products#displayUrlForm', as: 'product_url_form'
  get 'social/loaded' => 'products#socialFeedLoaded', as: 'social_feed_loaded'
  post 'list/new' => 'list#displayListForm', as: 'list_form'
  post 'list/create' => 'list#create', as: 'list_create'
  post 'list/addProduct' => 'list#addProductToList', as: 'list_add_product'


  get 'rankings' => 'ranking#index', as: 'ranking'

  match 'auth/:provider/callback', to: 'sessions#create', via: [:get, :post]
  match 'auth/failure', to: redirect('/'), via: [:get, :post]
  match 'signout', to: 'sessions#destroy', as: 'signout', via: [:get, :post]

  # viglets woo
  get 'viglets' => 'products#viglets', as: 'viglets'

  # admin stuff
  get 'admin' => 'admin#index', as: 'admin'
  get 'admin/login' => 'admin#login', as: 'admin_login'

  #signup process
  get 'step1' => 'profile#step_one', as: 'signup_step_one'
  patch 'step1complete' => 'profile#step_one_complete', as: 'signup_step_one_complete_patch'
  get 'step1complete' => 'profile#step_one_complete', as: 'signup_step_one_complete'
  get 'step2' => 'profile#step_two', as: 'signup_step_two'



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

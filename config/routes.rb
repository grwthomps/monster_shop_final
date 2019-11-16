Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  # root 'items#index'
  get '/', to: 'items#index'

  # resources :merchants do
  #   resources :items, only: [:index, :new, :create]
  # end

  get '/merchants', to: 'merchants#index'
  get '/merchants/new', to: 'merchants#new'
  get '/merchants/:id', to: 'merchants#show'
  get '/merchants/:id/edit', to: 'merchants#edit'
  patch '/merchants/:id', to: 'merchants#update'
  delete '/merchants/:id', to: 'merchants#destroy'
  post '/merchants', to: 'merchants#create'

  get '/merchants/:merchant_id/items', to: 'items#index'
  get '/merchants/:merchant_id/items/new', to: 'items#new'
  post '/merchants/:merchant_id/items', to: 'items#create'

  # resources :items, only: [:index, :show] do
  #   resources :reviews, only: [:new, :create]
  # end

  get '/items', to: 'items#index'
  get '/items/:id', to: 'items#show'

  get '/items/:item_id/reviews/new', to: 'reviews#new'
  post '/items/:item_id/reviews', to: 'reviews#create'

  # resources :reviews, only: [:edit, :update, :destroy]

  get '/reviews/:id/edit', to: 'reviews#edit'
  patch '/reviews/:id', to: 'reviews#update'
  delete '/reviews/:id', to: 'reviews#destroy'

  post '/cart/:item_id', to: 'cart#add_item'
  get '/cart', to: 'cart#show'
  delete '/cart', to: 'cart#empty'
  delete '/cart/:item_id', to: 'cart#remove_item'
  patch '/cart/:item_id/:increment_decrement', to: 'cart#increment_decrement'


  get '/profile', to: 'users#show'
  patch '/profile', to: 'users#update'
  get '/profile/edit', to: 'users#edit'
  get '/profile/orders', to: 'user_orders#index'
  get '/profile/orders/new', to: 'user_orders#new'
  get '/profile/orders/:id', to: 'user_orders#show'
  patch '/profile/orders/:id', to: 'user_orders#update'
  post '/profile/orders/:address_id', to: 'user_orders#create'
  get '/profile/addresses/:id/edit', to: 'addresses#edit'
  patch '/profile/addresses/:id', to: 'addresses#update'
  delete '/profile/addresses/:id', to: 'addresses#destroy'
  get '/profile/addresses/new', to: 'addresses#new'
  post '/profile/addresses', to: 'addresses#create'

  get '/register', to: 'users#new'
  post '/users', to: 'users#create'

  get '/login', to: 'sessions#new'
  post '/login', to: 'sessions#create'
  get '/logout', to: 'sessions#destroy'

  # namespace :merchant do
  #   resources :items, except: [:show]
  #
  #   root 'dashboard#index'
  #
  #   get '/orders/:id', to: 'orders#show'
  #   patch '/orders/:order_id/item_orders/:item_order_id', to: 'orders#update'
  # end

  get '/merchant/items', to: 'merchant/items#index'
  get '/merchant/items/new', to: 'merchant/items#new'
  get '/merchant/items/:id/edit', to: 'merchant/items#edit'
  patch '/merchant/items/:id', to: 'merchant/items#update'
  delete '/merchant/items/:id', to: 'merchant/items#destroy'
  post '/merchant/items', to: 'merchant/items#create'

  get '/merchant', to: 'merchant/dashboard#index'

  get 'merchant/orders/:id', to: 'merchant/orders#show'
  patch 'merchant/orders/:order_id/item_orders/:item_order_id', to: 'merchant/orders#update'

  # namespace :admin do
  #   resources :users, only: [:index, :show]
  #
  #   root 'dashboard#index'
  #
  #   get '/users/:id/orders', to: 'user_orders#index'
  #   get '/users/:user_id/orders/:order_id', to: 'user_orders#show'
  #   patch '/users/:user_id/orders/:order_id', to: 'user_orders#update'
  #
  #   get '/merchants/:id', to: 'dashboard#merchant_index'
  #   patch '/merchants/:id', to: 'merchants#update'
  #   get '/merchants/:merchant_id/orders/:order_id', to: 'merchant_orders#show'
  #   patch '/merchants/:merchant_id/orders/:order_id/item_orders/:item_order_id', to: 'merchant_orders#update'
  # end

  get '/admin/users', to: 'admin/users#index'
  get '/admin/users/:id', to: 'admin/users#show'

  get '/admin', to: 'admin/dashboard#index'

  get '/admin/users/:id/orders', to: 'admin/user_orders#index'
  get '/admin/users/:user_id/orders/:order_id', to: 'admin/user_orders#show'
  patch '/admin/users/:user_id/orders/:order_id', to: 'admin/user_orders#update'

  get '/admin/merchants/:id', to: 'admin/dashboard#merchant_index'
  patch '/admin/merchants/:id', to: 'admin/merchants#update'
  get '/admin/merchants/:merchant_id/orders/:order_id', to: 'admin/merchant_orders#show'
  patch '/admin/merchants/:merchant_id/orders/:order_id/item_orders/:item_order_id', to: 'admin/merchant_orders#update'
end

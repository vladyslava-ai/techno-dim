Rails.application.routes.draw do                         # [ЗГЕНЕРОВАНО] rails new
  # ---- власний код ----
  root "home#index"
  get "about", to: "pages#about", as: :about

  resources :products, only: [:index, :show] do          # /products, /products/1
    resources :reviews, only: :create                    # POST /products/1/reviews
  end

  get    "cart",                    to: "carts#show",        as: :cart
  post   "cart/add/:product_id",    to: "carts#add",         as: :add_to_cart
  patch  "cart/update/:product_id", to: "carts#update_item", as: :update_cart_item
  delete "cart/remove/:product_id", to: "carts#remove",      as: :remove_from_cart

  get    "favorites",               to: "favorites#index",   as: :favorites
  post   "favorites/:product_id",   to: "favorites#create",  as: :favorite
  delete "favorites/:product_id",   to: "favorites#destroy"

  get "compare", to: "comparisons#index", as: :compare
  post "compare/:product_id", to: "comparisons#add", as: :add_to_compare
  delete "compare/:product_id", to: "comparisons#remove", as: :remove_from_compare
  get "account", to: "accounts#show", as: :account

  resources :orders, only: [:index, :new, :create, :show]   # /orders/new — оформлення замовлення

  # автентифікація
  get    "login",    to: "sessions#new",     as: :login
  post   "login",    to: "sessions#create"
  delete "logout",   to: "sessions#destroy", as: :logout
  get    "register", to: "users#new",        as: :register
  post   "register", to: "users#create"

  # адмін-панель (доступ лише для admin)
  namespace :admin do
    resources :products, except: :show
    resources :reviews,   only: [:index, :update, :destroy]
    resources :suppliers, except: :show
    get "compare", to: "comparisons#index", as: :compare
  post "compare/:product_id", to: "comparisons#add", as: :add_to_compare
  delete "compare/:product_id", to: "comparisons#remove", as: :remove_from_compare
  get "account", to: "accounts#show", as: :account

  resources :orders, only: [:index, :update]
    get "stats", to: "stats#index", as: :stats
  end
end

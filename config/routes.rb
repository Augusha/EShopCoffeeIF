Rails.application.routes.draw do
  devise_for :users
  root 'home#index'

  post 'add_to_cart', to: 'cart_items#create', as: 'add_to_cart'
  resources :cart_items, only: [:create, :destroy]

  resources :products, only: [:index, :show, :new, :create, :edit, :update, :destroy]

  resources :products do
    resources :reviews, only: [:create]
  end

  resources :reviews, only: [:create, :update, :destroy]

  resources :feedbacks, only: [:new, :create, :index, :destroy]

  post 'checkout', to: 'orders#create', as: 'checkout'

  resources :orders, only: [:index, :show, :destroy]

  resources :orders do
    member do
      patch :update_status
    end
  end

end

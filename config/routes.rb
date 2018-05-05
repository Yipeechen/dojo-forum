Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :posts do
    resources :replies, only: [:create, :destroy]

    collection do
      get :feeds
    end

    member do
      post :favorite
      post :unfavorite
    end
  end
  resources :users, only: [:show, :edit, :update] do
    member do
      get :comment
      get :collect
    end
  end
  
  resources :categories, only: :show
  root "posts#index"

  namespace :admin do
    resources :categories
    root "categories#index"
  end
end

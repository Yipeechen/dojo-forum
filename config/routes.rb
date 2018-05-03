Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :posts, only: [:index, :new, :edit, :create, :show, :update, :destroy] do
    resources :replies, only: [:create, :destroy]
  end

  resources :categories, only: :show
  root "posts#index"

  namespace :admin do
    resources :posts
    resources :categories
    root "posts#index"
  end
end

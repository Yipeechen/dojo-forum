Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :posts, only: [:index, :new, :edit, :create, :show, :update, :destroy]
  root "posts#index"

  namespace :admin do
    resources :posts
    root "posts#index"
  end
end

Rails.application.routes.draw do
  devise_for :users
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  resources :posts do
    

    collection do
      get :feeds
      get :sort
    end

    member do
      post :favorite
      post :unfavorite
    end
  end
  
  resources :replies, only: [:create, :edit, :update, :destroy]
  resources :friendships, only: [:create, :destroy] do
    post :confirm
    delete :reject
  end


  resources :users, only: [:show, :edit, :update] do
    member do
      get :comment
      get :collect
      get :draft
      get :friend
    end
  end
  
  resources :categories, only: :show
  root "posts#index"

  namespace :admin do
    resources :categories
    root "categories#index"

    resources :users, only: [:index, :update]
  end

  namespace :api, defaults: {format: :json} do
    namespace :v1 do
      post "/login" => "auth#login"
      post "/logout" => "auth#logout"
      
      resources :posts, only: [:index, :show, :create, :update, :destroy]
    end
  end
end

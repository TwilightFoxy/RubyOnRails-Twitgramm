Rails.application.routes.draw do
  devise_for :users

  root to: "posts#index"

  resources :profiles, only: [:show]

  resources :posts, only: [:new, :create, :index, :destroy] do
    resources :comments, only: [:create, :destroy]
  end

  resources :likes, only: [:create, :destroy]


end

Rails.application.routes.draw do
  # Devise маршруты
  devise_for :users

  # Главная страница
  root to: "posts#index"

  # Кастомная страница профиля для текущего пользователя
  resource :profile, controller: 'profiles', only: [:show, :edit, :update]

  # Маршрут для просмотра профиля конкретного пользователя
  get 'user_profiles/:id', to: 'profiles#show', as: :user_profile

  # Маршрут для списка профилей
  resources :profiles, only: [:index]

  resources :posts, only: [:new, :create, :index, :destroy, :edit, :update, :show] do
    resources :comments, only: [:create, :destroy]
  end

  resources :likes, only: [:create, :destroy]
  resources :relationships, only: [:create, :destroy]

  get 'friends', to: 'profiles#friends', as: :friends
end

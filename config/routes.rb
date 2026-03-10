Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :users, only: [:show, :edit, :update]
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check

  resources :games, only: [:show]
  resources :collections do
    member do
      post 'add_game/:game_id', to: 'collections#add_game', as: :add_game
    end
  end
end

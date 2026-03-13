Rails.application.routes.draw do
  devise_for :users, controllers: { registrations: "users/registrations" }
  resources :users, only: [:show, :edit, :update]
  root to: "pages#home"

  get "up" => "rails/health#show", as: :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  # root "posts#index"

  # get "collections", to: "collections#index",
  resources :games, only: [:index, :show] do
    collection do
      get  :recommendation_form
      post :recommendation
    end
  end

  resources :collections do
    member do
      post 'add_game/:game_id', to: 'collections#add_game', as: :add_game
      # Ajoute cette ligne pour la suppression :
      delete 'remove_game/:game_id', to: 'collections#remove_game', as: :remove_game
    end
  end

  resources :collection_games, only: [:destroy]
end

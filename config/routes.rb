Rails.application.routes.draw do
  root :to => 'home#index'
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  resources :bookings, only: %i[new create show] do
    collection do
      get '/slot_history', to: 'bookings#slot_history'
      get '/vehicle_history', to: 'bookings#vehicle_history'
      get '/first_entry', to: 'bookings#first_entry'
      # post '/free_slot', to: 'bookings#free_slot'
      get '/close_shop', to: 'bookings#close_shop'
    end

    member do
      get '/free_slot', to: 'bookings#free_slot'
      post "/locations" => "bookings#location"
    end
  end

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", as: :rails_health_check

  # Defines the root path route ("/")
  # root "posts#index"
  require 'sidekiq/web'

  ParkingSlotFinder::Application.routes.draw do
    mount Sidekiq::Web => "/sidekiq"
  end
end

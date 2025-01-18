Rails.application.routes.draw do
  root 'locations#new'

  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create]

  resources :locations, only: [:new, :create] do
    resource :forecast, only: [:show]
  end
end

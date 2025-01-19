Rails.application.routes.draw do
  root "locations#index"

  resource :session, only: [:new, :create, :destroy]
  resources :users, only: [:new, :create]

  resources :locations, only: [:index, :new, :create, :destroy, :edit, :update] do
    resource :forecast, only: [:show]
  end
end

Rails.application.routes.draw do
  resources :locations, only: [:new, :create] do
    resource :forecast, only: [:show]
  end

  root 'locations#new'
end

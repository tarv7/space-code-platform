Rails.application.routes.draw do
  resources :pilots, only: :create
end

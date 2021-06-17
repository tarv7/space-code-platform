Rails.application.routes.draw do
  resources :pilots, only: :create
  resources :contracts, only: :create
end

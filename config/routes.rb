Rails.application.routes.draw do
  resources :pilots, only: :create
  resources :contracts, only: :create do
    get :opened, on: :collection, to: 'contracts/openeds#index'

    patch :accept, on: :member, to: 'contracts/accepteds#update'
  end
end

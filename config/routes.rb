# frozen_string_literal: true

Rails.application.routes.draw do
  mount Rswag::Ui::Engine => '/api-docs'
  mount Rswag::Api::Engine => '/api-docs'

  namespace :api do
    namespace :v1 do
      resources :pilots, only: :create

      resources :contracts, only: :create do
        get :opened, on: :collection, to: 'contracts/openeds#index'

        patch :accept, on: :member, to: 'contracts/accepteds#update'
      end

      resources :ships, only: [] do
        patch :fuel, on: :member, to: 'ships/fuel#update'
      end

      resources :travels, only: :create

      resources :reports, only: :index

      resources :planets, only: :index

      resources :travel_routes, only: :index
    end
  end
end

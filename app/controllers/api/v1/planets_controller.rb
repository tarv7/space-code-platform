# frozen_string_literal: true

module Api
  module V1
    class PlanetsController < ApplicationController
      def index
        render json: all_planets, status: :ok
      end

      private

      def all_planets
        Planet.all.order(created_at: :asc)
      end
    end
  end
end

# frozen_string_literal: true

module Api
  module V1
    class TravelRoutesController < ApplicationController
      def index
        render json: travel_routes_serialized, status: :ok
      end

      private

      def travel_routes_serialized
        TravelRouteSerializer.new.serializable_hash
      end
    end
  end
end

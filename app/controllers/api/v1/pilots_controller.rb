# frozen_string_literal: true

module Api
  module V1
    class PilotsController < ApplicationController
      def create
        pilot = Pilot.create!(pilot_params)

        render json: pilot, status: :created
      end

      private

      def pilot_params
        params.require(:pilot).permit(:certification, :name, :age, :credits, :location_id,
                                      ships_attributes: %i[fuel_capacity fuel_level weight_capacity])
      end
    end
  end
end

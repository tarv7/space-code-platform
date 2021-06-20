module Api
  module V1
    module Ships
      class FuelController < ApplicationController
        before_action :user_authenticate!

        def update
          RefilFuel.call!(ship, fuel_params[:quantity].to_i)

          render json: ship, status: :ok
        end

        private

        def ship
          @_ship ||= current_pilot.ships.find(ship_params[:id])
        end

        def fuel_params
          params.permit(:quantity)
        end

        def ship_params
          params.permit(:id)
        end
      end
    end
  end
end

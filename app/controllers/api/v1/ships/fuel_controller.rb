module Api
  module V1
    module Ships
      class FuelController < ApplicationController
        def update
          ship = Ship.find(ship_params[:id])

          RefilFuel.call!(ship, fuel_params[:quantity].to_i)

          render json: ship, status: :ok
        end

        private

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

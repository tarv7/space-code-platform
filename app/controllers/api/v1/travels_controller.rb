# frozen_string_literal: true

module Api
  module V1
    class TravelsController < ApplicationController
      before_action :user_authenticate!

      def create
        Travel.call!(contract: contract, ship_id: contract_params[:ship_id])

        render json: contract, include: 'origin,destiny,pilot.ships', status: :ok
      end

      private

      def contract
        @_contract ||= current_pilot.contracts.accepted.find(contract_params[:id])
      end

      def contract_params
        params.permit(:id, :ship_id)
      end
    end
  end
end

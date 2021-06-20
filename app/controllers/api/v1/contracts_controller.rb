module Api
  module V1
    class ContractsController < ApplicationController
      def create
        contract = Contract.create!(contract_params)

        render json: contract, status: :created
      end

      private

      def contract_params
        params.require(:contract).permit(:description, :value, :payload_weight, :payload_id, :origin_id, :destiny_id)
      end
    end
  end
end
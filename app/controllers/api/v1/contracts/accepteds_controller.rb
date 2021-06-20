# frozen_string_literal: true

module Api
  module V1
    module Contracts
      class AcceptedsController < ApplicationController
        before_action :user_authenticate!

        def update
          contract.accept!(current_pilot)

          render json: contract, status: :ok
        end

        private

        def contract
          @_contract ||= Contract.find(contract_params[:id])
        end

        def contract_params
          params.permit(:id)
        end
      end
    end
  end
end

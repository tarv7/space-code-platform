module Api
  module V1
    module Contracts
      class OpenedsController < ContractsController
        def index
          contracts = Contract.opened

          render json: contracts, status: :ok
        end
      end
    end
  end
end

module Contracts
  class AcceptedsController < ContractsController
    def update
      contract = Contract.find(contract_params[:id])

      contract.accept!(current_pilot)

      render json: contract, status: :ok
    end

    private

    def contract_params
      params.permit(:id)
    end
  end
end
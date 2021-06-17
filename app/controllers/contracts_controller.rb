class ContractsController < ApplicationController
  def create
    contract = Contract.create!(contract_params)

    render json: contract, status: :created
  rescue StandardError => e
    render json: { message: e.message }, status: :bad_request
  end

  private

  def contract_params
    params.require(:contract).permit(:description, :value, :payload_weight, :payload_id, :origin_id, :destiny_id)
  end
end

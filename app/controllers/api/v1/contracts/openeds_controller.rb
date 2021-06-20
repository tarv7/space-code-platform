module Api
  module V1
    module Contracts
      class OpenedsController < ApplicationController
        def index
          contracts = Contract.opened

          render json: contracts, status: :ok
        end
      end
    end
  end
end

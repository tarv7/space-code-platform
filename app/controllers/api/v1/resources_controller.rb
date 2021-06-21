# frozen_string_literal: true

module Api
  module V1
    class ResourcesController < ApplicationController
      def index
        render json: all_resources, status: :ok
      end

      private

      def all_resources
        Resource.all
      end
    end
  end
end

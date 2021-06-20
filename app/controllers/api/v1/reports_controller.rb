# frozen_string_literal: true

module Api
  module V1
    class ReportsController < ApplicationController
      ALLOWED_TYPES = %w[by_planet by_pilot transaction].freeze

      before_action :verify_type

      def index
        render json: serialized_report, status: :ok
      end

      private

      def verify_type
        return if ALLOWED_TYPES.include?(report_params[:type])

        render json: { message: I18n.t('errors.report.type_not_exists') }, status: :not_acceptable
      end

      def serialized_report
        "Reports::#{report_params[:type].camelize}Serializer".constantize.new.serializable_hash
      end

      def report_params
        params.permit(:type)
      end
    end
  end
end

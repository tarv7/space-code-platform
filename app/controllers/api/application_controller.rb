# frozen_string_literal: true

module Api
  class ApplicationController < ::ApplicationController
    class AuthenticateError < StandardError; end

    rescue_from StandardError, with: :handle_standard_error
    rescue_from ActiveRecord::RecordNotFound, with: :handle_record_not_found_error

    private

    def user_authenticate!
      current_pilot.present?
    rescue ActiveRecord::RecordNotFound
      raise AuthenticateError, I18n.t('errors.need_log_into')
    end

    def current_pilot
      @_current_pilot ||= Pilot.find(request.headers['auth-pilot-id'].to_i)
    end

    def handle_record_not_found_error(exception)
      render json:
      {
        message: I18n.t('errors.record_not_found', model: exception.model, id: exception.id)
      }, status: :bad_request
    end

    def handle_standard_error(exception)
      render json: { message: exception.message }, status: :bad_request
    end
  end
end

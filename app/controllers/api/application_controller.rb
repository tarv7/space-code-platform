module Api
  class ApplicationController < ::ApplicationController
    class AuthenticateError < StandardError; end

    rescue_from StandardError, with: :handle_standard_error

    private

    def user_authenticate!
      current_pilot.present?
    rescue ActiveRecord::RecordNotFound
      raise AuthenticateError, 'You need to log into the system'
    end

    def current_pilot
      @_current_pilot ||= Pilot.find(request.headers['auth-pilot-id'].to_i)
    end

    def handle_standard_error(exception)
      render json: { message: exception.message }, status: :bad_request
    end
  end
end

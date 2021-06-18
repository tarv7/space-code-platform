class ApplicationController < ActionController::API
  rescue_from StandardError, with: :standard_error

  protected

  def current_pilot
    @_current_pilot ||= Pilot.find(request.headers["auth-pilot-id"].to_i)
  end

  private

  def standard_error(exception)
    render json: { message: exception.message }, status: :bad_request
  end
end

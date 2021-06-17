class ApplicationController < ActionController::API
  rescue_from StandardError, with: :standard_error

  private

  def standard_error(exception)
    render json: { message: exception.message }, status: :bad_request
  end
end

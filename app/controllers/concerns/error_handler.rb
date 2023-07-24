module ErrorHandler
  class AuthenticationError < StandardError; end
  class ExpiredTokenError < AuthenticationError; end

  extend ActiveSupport::Concern

  included do
    rescue_from ActiveRecord::RecordNotFound, with: :render_exception
    rescue_from ActionController::ParameterMissing, with: :render_exception
    rescue_from ActiveRecord::RecordInvalid, with: :record_invalid
    rescue_from AuthenticationError, with: :auth_invalid
    rescue_from ExpiredTokenError, with: :token_expired
  end

  private

  def auth_invalid(error)
    errors = [{
      status: :unauthorized,
      title: 'Unauthorized',
      detail: error.message,
      path: request.path
    }]
    render json: { errors: }, status: errors.first[:status]
  end

  def token_expired(error)
    errors = [{
      status: :unauthorized,
      title: 'Token Expired',
      detail: error.message,
      path: request.path
    }]
    render json: { errors: }, status: errors.first[:status]
  end

  def render_exception(error)
    errors = [{
      status: get_status(error),
      title: error.class.name.demodulize.underscore.humanize,
      detail: error.message,
      path: request.path
    }]
    render json: { errors: }, status: errors.first[:status]
  end

  def get_status(error)
    case error
    when ActiveRecord::RecordNotFound
      404
    when ActionController::ParameterMissing
      400
    else
      500
    end
  end

  def record_invalid(error)
    errors = error.record.errors.messages.map do |field, messages|
      messages.map do |message|
        {
          status: 422,
          title: 'Validation Error',
          detail: "#{error.record.class.human_attribute_name(field)}#{message}",
          source: {
            pointer: field.to_s
          }
        }
      end
    end.flatten
    render json: { errors: }, status: errors.first[:status]
  end

end

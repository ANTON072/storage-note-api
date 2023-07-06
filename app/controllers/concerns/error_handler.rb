module ErrorHandler
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
    render_errors([{
                    status: :unauthorized,
                    title: 'Unauthorized',
                    detail: error.message,
                    path: request.path
                  }])
  end

  def token_expired(error)
    render_errors([{
                    status: :unauthorized,
                    title: 'Token Expired',
                    detail: error.message,
                    path: request.path
                  }])
  end

  def render_exception(error)
    render_errors([{
                    status: get_status(error),
                    title: error.class.name.demodulize.underscore.humanize,
                    detail: error.message,
                    path: request.path
                  }])
  end

  def get_status(error)
    case error
    when ActiveRecord::RecordNotFound
      :not_found
    when ActionController::ParameterMissing
      :bad_request
    else
      :internal_server_error
    end
  end

  def record_invalid(error)
    errors = error.record.errors.map do |field, message|
      {
        status: :unprocessable_entity,
        title: 'Validation Error',
        detail: "#{field.to_s.humanize} #{message}",
        source: {
          pointer: "/data/attributes/#{field}"
        }
      }
    end
    render_errors(errors)
  end

  def render_errors(errors)
    formatted_errors = errors.map do |error|
      {
        status: error[:status].to_s,
        title: error[:title],
        detail: error[:detail],
        source: {
          pointer: error[:path]
        }
      }
    end

    render json: { errors: formatted_errors }, status: errors.first[:status]
  end
end

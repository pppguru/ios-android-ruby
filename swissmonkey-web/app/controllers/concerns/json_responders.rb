# JSON responders
module JsonResponders
  extend ActiveSupport::Concern

  protected

  def respond_with_400(payload)
    render json: payload, status: 400
  end

  def respond_with_error(message)
    render json: { error: message }, status: 400
  end

  def respond_with_success(message)
    render json: { success: message }, status: 200
  end

  def respond_with_try_again
    respond_with_400 'Something went wrong. Please try again later.'
  end
end

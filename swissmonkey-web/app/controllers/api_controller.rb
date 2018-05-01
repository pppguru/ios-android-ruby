# parent class for all API controllers
class ApiController < ActionController::Base
  include JsonResponders

  before_action do
    request.format = :json
  end

  # protect_from_forgery with: :exception
end

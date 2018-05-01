# parent class for all controllers
class ApplicationController < ActionController::Base
  include JsonResponders
  protect_from_forgery with: :null_session

  def api_test
    x = SoftwareProficiency.join_recursive do |query|
      query.start_with(parent_id: nil)
           .connect_by(id: :parent_id)
           .order_siblings(:name)
    end

    render json: x
  end
end

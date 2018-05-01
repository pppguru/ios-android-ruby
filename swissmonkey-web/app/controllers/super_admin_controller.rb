# uber-powerful controller for developer admins only
class SuperAdminController < ApplicationController
  before_action :authenticate_admin!

  def index; end
end

# parent class for all authenticated controllers
class AuthenticatedController < ApplicationController
  before_action :authenticate_user!, except: :api_test
  before_action :set_company_context

  protected

  def set_company_context
    return unless user_signed_in?

    @company_context ||= current_user.last_company_context || current_user.companies.first
  end
end

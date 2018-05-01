require 'rails_helper'

RSpec.describe NotificationController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { FactoryGirl.create(:user) }

  describe 'GET #mark_read' do
    it 'returns http success' do
      sign_in user
      get :mark_read
      expect(response).to have_http_status(:success)
    end
  end
end

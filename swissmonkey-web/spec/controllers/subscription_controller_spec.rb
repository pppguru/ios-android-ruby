require 'rails_helper'

RSpec.describe SubscriptionController, type: :controller do
  include Devise::Test::ControllerHelpers
  let(:user) { FactoryGirl.create(:user) }

  before :each do
    sign_in user
  end

  describe 'GET #summary' do
    it 'returns http success' do
      get :summary, xhr: true
      expect(response).to have_http_status(:success)
    end
  end
end

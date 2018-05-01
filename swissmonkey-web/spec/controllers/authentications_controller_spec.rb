require 'rails_helper'

RSpec.describe AuthenticationsController, type: :controller do
  include Devise::Test::ControllerHelpers

  before do
    set_omniauth
  end

  describe 'GET #facebook' do
    before do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:facebook]
    end
    it 'returns http success' do
      get :facebook
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #google' do
    before do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:google_oauth2]
    end
    it 'returns http success' do
      get :google
      expect(response).to redirect_to(root_path)
    end
  end

  describe 'GET #linkedin' do
    before do
      request.env['omniauth.auth'] = OmniAuth.config.mock_auth[:linkedin]
    end
    it 'returns http success' do
      get :linkedin
      expect(response).to redirect_to(root_path)
    end
  end
end

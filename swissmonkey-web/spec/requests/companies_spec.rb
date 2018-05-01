require 'rails_helper'

RSpec.describe 'Companies', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  before :each do
    sign_in user
  end

  describe 'GET /companies' do
    it 'works! (now write some real specs)' do
      get companies_path
      expect(response).to have_http_status(200)
    end
  end
end

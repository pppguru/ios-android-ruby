require 'rails_helper'

RSpec.describe 'SuperAdmin::Users', type: :request do
  let(:admin) { FactoryGirl.create(:admin) }
  before :each do
    sign_in admin
  end

  describe 'GET /super_admin/users' do
    it 'works! (now write some real specs)' do
      get super_admin_users_path
      expect(response).to have_http_status(200)
    end
  end
end

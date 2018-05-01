require 'rails_helper'

RSpec.describe 'SuperAdmin::JobPostings', type: :request do
  let(:admin) { FactoryGirl.create(:admin) }
  before :each do
    sign_in admin
  end

  describe 'GET /super_admin_job_postings' do
    it 'works! (now write some real specs)' do
      get super_admin_job_postings_path
      expect(response).to have_http_status(200)
    end
  end
end

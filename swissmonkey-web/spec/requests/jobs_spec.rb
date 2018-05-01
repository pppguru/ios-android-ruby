require 'rails_helper'

RSpec.describe 'Jobs', type: :request do
  let(:user) { FactoryGirl.create(:user) }
  before :each do
    sign_in user
  end

  describe 'GET /job_postings' do
    it 'works! (now write some real specs)' do
      get job_postings_path
      expect(response).to have_http_status(200)
    end
  end
end

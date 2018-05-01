require 'rails_helper'

RSpec.describe 'CompanyContextSwitching', type: :request do
  let(:user) { FactoryGirl.create(:user, role: 'EMPLOYER') }
  let(:company1) { FactoryGirl.create(:company, name: 'ACME Dental') }
  let(:company2) { FactoryGirl.create(:company, name: 'Zulu Dental') }

  before :each do
    user.companies << company1
    user.companies << company2
  end

  it 'assumes the first company if none set' do
    sign_in user
    get job_postings_path

    expect(assigns(:company_context)).to eq(company1)

    expect(response).to have_http_status(200)
  end

  it 'remembers the last active company across page loads and sessions' do
    sign_in user
    get job_postings_path

    expect(assigns(:company_context)).to eq(company1)

    post set_current_company_account_path(company2)
    get job_postings_path

    expect(user.reload.last_company_context).to eq(company2)

    expect(assigns(:company_context)).to eq(company2)

    sign_out user
    get root_path

    sign_in user
    get job_postings_path

    expect(assigns(:company_context)).to eq(company2)
  end
end

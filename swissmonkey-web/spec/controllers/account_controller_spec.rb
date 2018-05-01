require 'rails_helper'

RSpec.describe AccountController, type: :controller do
  include Devise::Test::ControllerHelpers

  describe 'POST #set_current_company' do
    let(:user) { FactoryGirl.create(:user, role: 'EMPLOYER') }
    let(:company) { FactoryGirl.create(:company) }
    let(:company2) { FactoryGirl.create(:company) }
    let(:id) { company.id }
    let(:destination) { nil }

    let(:subject) do
      post :set_current_company, params: { id: id, destination: destination }
    end

    before :each do
      user.companies << company
      sign_in user
    end

    context 'company does not belong to user' do
      let(:id) { company2.id }
      it 'renders 404' do
        subject
        expect(response).to have_http_status(404)
      end
    end

    context 'company does not exist' do
      let(:id) { -1 }
      it 'renders 404' do
        subject
        expect(response).to have_http_status(404)
      end
    end

    context 'company exists and belongs to user' do
      before(:each) { subject }

      it 'sets current_user.last_company_context' do
        expect(user.reload.last_company_context).to eq(company)
      end

      context 'destination provided as /companies' do
        let(:destination) { companies_path }
        it 'redirects to /companies' do
          expect(response).to redirect_to(companies_path)
        end
      end

      context 'no destination provided' do
        it 'redirects to /job_postings' do
          expect(response).to redirect_to(job_postings_path)
        end
      end
    end
  end

  describe 'GET #verify_email_change' do
    let(:new_email) { 'test@tester.co' }
    let(:subject) { get :verify_email_change, params: { token: new_email } }
    let(:user) { FactoryGirl.create(:user, new_email: new_email) }
    let(:user2) { FactoryGirl.create(:user, email: 'another.user@altogeth.er') }

    context 'current user matches email change request' do
      before(:each) { sign_in user }

      it 'updates the account' do
        expect(user.email).not_to eq(new_email)
        subject
        user.reload
        expect(user.email).to eq(new_email)
      end

      it 'redirects to root page' do
        subject
        expect(response).to redirect_to('/')
      end
    end

    context 'current user does not match email change request' do
      before(:each) { sign_in user2 }

      it 'responds with 401' do
        subject
        expect(response).to have_http_status(401)
      end
    end
  end
end

require 'rails_helper'

RSpec.describe Api::V1Controller, type: :controller do
  include Devise::Test::ControllerHelpers

  let(:json) { JSON.parse(response.body) }

  render_views

  describe 'GET #datasets' do
    let(:token) { nil }

    let(:datasets) { JSON.parse(response.body) }
    let(:systems) { datasets['praticeManagementSoftware'] }
    let(:system_ids) { systems.map { |s| s['software_id'] } }

    let(:subject) { get :datasets, params: { authtoken: token } }
    let(:user1) { FactoryGirl.create(:user, name: 'Joe Joe', role: 'JOBSEEKER', token: 'abc') }
    let(:user2) { FactoryGirl.create(:user, name: 'Joe Joe', role: 'JOBSEEKER', token: 'def') }

    let!(:pm1) { FactoryGirl.create(:practice_management_system, visible_to: 'all') }
    let!(:pm2) { FactoryGirl.create(:practice_management_system, visible_to: 'all') }
    let!(:pm3) { FactoryGirl.create(:practice_management_system, visible_to: user1.id) }
    let!(:pm4) { FactoryGirl.create(:practice_management_system, visible_to: user2.id) }

    before(:each) { subject }

    context 'no active user' do
      it 'should show pm systems marked visible to all' do
        expect(system_ids).to include(pm1.id)
        expect(system_ids).to include(pm2.id)
      end
      it 'should not show pm systems marked visible to user 1 or user 2' do
        expect(system_ids).not_to include(pm3.id)
        expect(system_ids).not_to include(pm4.id)
      end
    end
    context 'active user 1' do
      let(:token) { 'abc' }
      it 'should show pm systems marked visible to all' do
        expect(system_ids).to include(pm1.id)
        expect(system_ids).to include(pm2.id)
      end
      it 'should show pm systems marked visible to user 1' do
        expect(system_ids).to include(pm3.id)
      end
      it 'should not show pm systems marked visible to user 2' do
        expect(system_ids).not_to include(pm4.id)
      end
    end
    context 'active user 2' do
      let(:token) { 'def' }
      it 'should show pm systems marked visible to all' do
        expect(system_ids).to include(pm1.id)
        expect(system_ids).to include(pm2.id)
      end
      it 'should show pm systems marked visible to user 2' do
        expect(system_ids).to include(pm4.id)
      end
      it 'should not show pm systems marked visible to user 1' do
        expect(system_ids).not_to include(pm3.id)
      end
    end
  end
end

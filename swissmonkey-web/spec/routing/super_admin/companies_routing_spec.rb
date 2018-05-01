require 'rails_helper'

RSpec.describe SuperAdmin::CompaniesController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/super_admin/companies').to route_to('super_admin/companies#index')
    end

    it 'routes to #new' do
      expect(get: '/super_admin/companies/new').to route_to('super_admin/companies#new')
    end

    it 'routes to #show' do
      expect(get: '/super_admin/companies/1').to route_to('super_admin/companies#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/super_admin/companies/1/edit').to route_to('super_admin/companies#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/super_admin/companies').to route_to('super_admin/companies#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/super_admin/companies/1').to route_to('super_admin/companies#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/super_admin/companies/1').to route_to('super_admin/companies#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/super_admin/companies/1').to route_to('super_admin/companies#destroy', id: '1')
    end
  end
end

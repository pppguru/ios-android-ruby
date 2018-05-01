require 'rails_helper'

RSpec.describe SuperAdmin::UsersController, type: :routing do
  describe 'routing' do
    it 'routes to #index' do
      expect(get: '/super_admin/users').to route_to('super_admin/users#index')
    end

    it 'routes to #new' do
      expect(get: '/super_admin/users/new').to route_to('super_admin/users#new')
    end

    it 'routes to #show' do
      expect(get: '/super_admin/users/1').to route_to('super_admin/users#show', id: '1')
    end

    it 'routes to #edit' do
      expect(get: '/super_admin/users/1/edit').to route_to('super_admin/users#edit', id: '1')
    end

    it 'routes to #create' do
      expect(post: '/super_admin/users').to route_to('super_admin/users#create')
    end

    it 'routes to #update via PUT' do
      expect(put: '/super_admin/users/1').to route_to('super_admin/users#update', id: '1')
    end

    it 'routes to #update via PATCH' do
      expect(patch: '/super_admin/users/1').to route_to('super_admin/users#update', id: '1')
    end

    it 'routes to #destroy' do
      expect(delete: '/super_admin/users/1').to route_to('super_admin/users#destroy', id: '1')
    end
  end
end

require 'rails_helper'

RSpec.describe AccountController, type: :routing do
  describe 'routing' do
    it 'POST #set_current_context' do
      expect(post: '/account/set_current_company/1').to route_to('account#set_current_company', id: '1')
    end
  end
end

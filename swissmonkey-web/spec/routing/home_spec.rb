require 'rails_helper'

RSpec.describe 'home routes', type: :routing do
  it 'GET / is routable' do
    expect(get: '/').to route_to(controller: 'home', action: 'index')
  end
end

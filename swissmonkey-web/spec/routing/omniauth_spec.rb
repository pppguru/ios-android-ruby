require 'rails_helper'

RSpec.describe 'schedule routes', type: :routing do
  it 'GET /auth/facebook/callback is routable' do
    expect(get: '/auth/facebook/callback').to route_to(controller: 'authentications', action: 'facebook')
  end

  it 'GET /auth/google/callback is routable' do
    expect(get: '/auth/google_oauth2/callback').to route_to(controller: 'authentications', action: 'google')
  end

  it 'GET /auth/linkedin/callback is routable' do
    expect(get: '/auth/linkedin/callback').to route_to(controller: 'authentications', action: 'linkedin')
  end
end

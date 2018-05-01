def set_omniauth
  %i[facebook linkedin google_oauth2].each do |provider|
    omniauth_config = { 'provider': provider,
                        'uid': '12345',
                        'info': {
                          'name': 'fake',
                          'email': 'fake1@test.com'
                        } }
    OmniAuth.config.add_mock(provider, omniauth_config)
  end
end

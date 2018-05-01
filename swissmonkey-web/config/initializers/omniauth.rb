Rails.application.config.middleware.use OmniAuth::Builder do
  provider :facebook, ENV['FACEBOOK_APP_ID'], ENV['FACEBOOK_APP_SECRET'], scope: 'public_profile,email'
  provider :google_oauth2, ENV['GOOGLE_APP_ID'], ENV['GOOGLE_APP_SECRET'], scope: 'userinfo.email,userinfo.profile'
  provider :linkedin, ENV['LINKED_IN_APP_ID'], ENV['LINKED_IN_APP_SECRET']
  on_failure { |env| AuthenticationsController.action(:failure).call(env) }
end

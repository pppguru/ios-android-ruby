Rails.application.routes.draw do
  get 'subscription/summary'
  get 'notification/count'
  get 'notification/change_count'
  get 'notification/mark_read'

  get 'api_test' => 'application#api_test'

  namespace :api do
    namespace 'v1', path: 'v1.0' do # as v1.0', controller: 'v1', as: 'v1' do
      get 'dropdown/data', action: 'datasets'

      namespace :user do
        post 'signup'
        post 'login'
        post 'logout'
        post 'forgot'
        post 'reset'
        post 'validate'
        post 'deactivate'
        post 'activate'
        post 'deviceregistration', action: 'device_registration'
        post 'accept_privacy_policy'
        post 'privacy_policy_status'
      end

      namespace :job do
        post 'details/:id', action: 'details'
        post 'search'
        post 'save'
        post 'apply'
        post 'jobs'
        post 'applications'
        post 'savedjobs'
        post 'history'
      end

      namespace :profile do
        post 'save'
        post 'upload'
        post 'download'
        post 'info'
        post 'delete'
      end

      namespace :settings do
        post 'apinotifications'
        post 'update'
        post 'viewed'
      end
    end
  end

  namespace :authentications do
    get 'facebook'
    get 'google'
    get 'linkedin'
  end

  namespace :stripe do
    post 'apply_coupon'
    post 'delete_card'
    post 'check_location_payment'
  end

  resources :applicants # , only: :index
  resources :companies do
    post 'set_current_context'
  end
  resources :job_postings
  get 'profile/me' => 'profiles#me', as: 'my_profile'
  resources :profiles
  resource :account, controller: 'account' do
    get 'verify_email_change'
    post 'set_current_company/:id', action: 'set_current_company', as: 'set_current_company'
  end
  resource :subscription

  get 'super_admin' => 'super_admin#index'
  namespace :super_admin do
    resources :companies
    resources :job_postings
    resources :users
  end

  devise_for :admins
  devise_for :users, controllers: {
    sessions: 'users/sessions',
    registrations: 'users/registrations'
  }

  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  get '/auth/facebook/callback' => 'authentications#facebook'
  get '/auth/google_oauth2/callback' => 'authentications#google'
  get '/auth/linkedin/callback' => 'authentications#linkedin'

  # legacy paths
  match 'publishJob/:id' => 'job_postings#publish_job', via: %i[get post]
  match 'accountSettings' => 'profile#account_settings', via: %i[get post]
  match 'alertnotification' => 'profile#alert_notification', via: %i[get post]

  root 'home#index'
end

Rails.application.configure do
  config.stripe_publishable_key = ENV['STRIPE_PUBLISHABLE_KEY']
  config.stripe_secret_key = ENV['STRIPE_SECRET_KEY']
end

Stripe.api_key = ENV['STRIPE_SECRET_KEY']

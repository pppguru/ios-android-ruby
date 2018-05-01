# RSpec.configure do |config|
#   config.include Rails.application.routes.url_helpers
# end

def setup_stripe_plans
  return unless Stripe::Plan.all.count.zero?
  stripe_helper = StripeMock.create_test_helper
  stripe_helper.create_plan(id: :free, amount: 0)
  stripe_helper.create_plan(id: :basic, amount: 3000)
  stripe_helper.create_plan(id: :monthly, amount: 4900)
  stripe_helper.create_plan(id: :annual, amount: 30_000)
end

def add_card_for_stripe_customer(company)
  customer = company.stripe_customer
  customer.sources.create(card: { name: 'Broah Lively', number: '4111111111111111', exp_month: 12, exp_year: 2020 })
end

def mock_webhook_and_create_log(webhook_name, params)
  webhook = StripeMock.mock_webhook_event(webhook_name, params)
  webhook_hash = JSON.parse(webhook.to_json)
  StripeEventLog.create_from_webhook webhook_hash
end

def create_and_subscribe_company(company_params = nil)
  company = if company_params.present?
              FactoryGirl.create(:company, company_params)
            else
              FactoryGirl.create(:company)
            end
  add_card_for_stripe_customer(company)
  company.apply_subscription :monthly

  company
end

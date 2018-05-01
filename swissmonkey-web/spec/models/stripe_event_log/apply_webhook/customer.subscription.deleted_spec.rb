require 'rails_helper'

RSpec.describe StripeEventLog, type: :model do
  describe 'customer.subscription.deleted' do
    let(:stripe_helper) { StripeMock.create_test_helper }
    before { StripeMock.start }
    after { StripeMock.stop }
    before(:each) do
      setup_stripe_plans
      @double = class_double('Boomr::SendGrid').as_stubbed_const(transfer_nested_constants: true)
      allow(@double).to receive(:send_transactional)
    end

    let(:webhook) { 'customer.subscription.deleted' }
    before { @company = create_and_subscribe_company }

    context 'before webhook received' do
      it 'company stripe_subscription_id should be present' do
        expect(@company.stripe_subscription_id).to be_present
      end
      it 'company should be active' do
        expect(@company.active).to be_truthy
      end
    end

    context 'after webhook received' do
      before :each do
        @log = mock_webhook_and_create_log(webhook,
                                           id: @company.stripe_subscription_id,
                                           customer: @company.stripe_customer_id)
        @company.reload
      end

      it 'log record should have same customer id as company' do
        expect(@log.customer_id).to eq(@company.stripe_customer_id)
      end

      it 'company should be deactivated' do
        expect(@company.active).to be_falsey
      end
    end
  end
end

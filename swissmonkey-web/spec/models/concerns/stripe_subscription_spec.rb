require 'rails_helper'
require 'stripe_mock'

RSpec.describe Company, type: :model do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { StripeMock.start }
  after { StripeMock.stop }

  before :each do
    setup_stripe_plans
  end

  let(:company) { create_and_subscribe_company }

  describe 'StripeSubscription concern' do
    describe 'subscribe?' do
      context 'company is on trial' do
        let(:company) { FactoryGirl.create(:company, trial: true) }
        it 'should be false' do
          expect(company.subscribed?).to be_falsey
        end
      end

      context 'company is not on trial' do
        let(:company) { FactoryGirl.create(:company, trial: false) }
        context 'company has a stripe_subscription_id' do
          it 'should be true' do
            company.stripe_subscription_id = 'abcdefg'
            expect(company.subscribed?).to be_truthy
          end
        end
        context 'company does not have a stripe_subscription_id' do
          it 'should be false' do
            expect(company.subscribed?).to be_falsey
          end
        end
      end
    end
    describe 'stripe_subscription' do
      context 'company is subscribed' do
        it 'should return an instance of Stripe::Subscription' do
          expect(company.stripe_subscription).to be_a(Stripe::Subscription)
        end
      end

      context 'company is not subscribed' do
        it 'should return nil' do
          company = FactoryGirl.create :company, email: 'notsubscribed@anywhere.io'
          expect(company.stripe_subscription).to be_nil
        end
      end
    end

    describe 'stripe_customer' do
      it 'should return an instance of Stripe::Customer' do
        expect(company.stripe_customer).to be_a(Stripe::Customer)
      end
    end

    describe 'add_stripe_card' do
      it 'card should be created' do
        customer = company.stripe_customer

        existing_count = customer.sources.all.count

        company.add_stripe_card('4242424242424242', 'Broah Lively', '03', '2019')

        expect(customer.sources.all.count).to be > existing_count
      end

      context 'default param set to true' do
        it 'should save stripe customer' do
          expect_any_instance_of(Stripe::Customer).to receive(:save)
          company.add_stripe_card('4242424242424242', 'Broah Lively', '03', '2019', true)
        end
      end
    end

    describe 'stripe_cards' do
      describe 'return data' do
        before :each do
          company2 = create_and_subscribe_company email: 'asfsdfasdfwre@asfasdf.csdf'
          customer = company.stripe_customer
          customer2 = company2.stripe_customer
          token1 = StripeMock.generate_card_token(last4: '1111', exp_year: 1984)
          token2 = StripeMock.generate_card_token(last4: '2222', exp_year: 1984)
          token3 = StripeMock.generate_card_token(last4: '4242', exp_year: 1984)
          @card1 = customer.sources.create(source: token1)
          @card2 = customer.sources.create(source: token2)
          @card3 = customer2.sources.create(source: token3)
          @response = company.stripe_cards
          @response2 = company2.stripe_cards
        end

        describe 'first call (not cached)' do
          it 'result set should be an array' do
            expect(@response).to be_an(Array)
          end
        end

        describe 'second call (cached)' do
          it 'result set should be an array' do
            second_response = company.stripe_cards
            expect(second_response).to be_an(Array)
          end
        end

        it 'should include the invoices belonging to the company' do
          expect(@response.map(&:id)).to include(@card1.id)
          expect(@response.map(&:id)).to include(@card2.id)
        end

        it 'should not include data belonging to another company' do
          expect(@response.map(&:id)).not_to include(@card3.id)
          expect(@response2.map(&:id)).to include(@card3.id)
        end
      end
    end

    describe 'stripe_invoices' do
      describe 'caching' do
        before :each do
          @stripe_double = class_double('Stripe::Invoice').as_stubbed_const
          allow(@stripe_double).to receive(:all)
        end

        context 'cache data missing or invalid' do
          before :each do
            @response = company.stripe_invoices
          end

          it 'should make an api call to stripe' do
            expect(@stripe_double).to have_received(:all).once
          end
        end

        context 'cache data valid' do
          before :each do
            @result1 = company.stripe_invoices
            @result2 = company.stripe_invoices
            @result3 = company.stripe_invoices
          end

          it 'should not have made >1 api calls to stripe' do
            expect(@stripe_double).to have_received(:all).once
          end
        end
      end

      describe 'return data' do
        before :each do
          @invoice1 = Stripe::Invoice.create(customer: company.stripe_customer_id, amount_due: 10_000)
          @invoice2 = Stripe::Invoice.create(customer: company.stripe_customer_id, amount_due: 200)
          @invoice3 = Stripe::Invoice.create(customer: 'abcdfasfadlfhaw;fhsl;a', amount_due: 200)
          @response = company.stripe_invoices
        end

        describe 'first call (not cached)' do
          it 'result set should be an array' do
            expect(@response).to be_an(Array)
          end
        end

        describe 'second call (cached)' do
          it 'result set should be an array' do
            second_response = company.stripe_invoices
            expect(second_response).to be_an(Array)
          end
        end

        it 'should include the invoices belonging to the company' do
          expect(@response.map(&:id)).to include(@invoice1.id)
          expect(@response.map(&:id)).to include(@invoice2.id)
        end

        it 'should not include data belonging to another company' do
          expect(@response.map(&:id)).not_to include(@invoice3.id)
        end
      end
    end

    describe 'before conversion' do
      let(:company) { FactoryGirl.create(:company) }

      it 'trial should be true' do
        expect(company.trial).to be_truthy
      end
      it 'stripe_plan should be nil' do
        expect(company.stripe_plan).to be_nil
      end
      it 'stripe_customer_id should not be nil' do
        expect(company.stripe_customer_id).not_to be_nil
      end
      it 'stripe_subscription_id should be nil' do
        expect(company.stripe_subscription_id).to be_nil
      end
      it 'initial_conversion_date should be nil' do
        expect(company.initial_conversion_date).to be_nil
      end
    end

    describe 'conversion' do
      describe 'initial conversion' do
        before :each do
          company.apply_subscription(:free)
          @subscription_id_after_first_conversion = company.stripe_subscription_id
        end

        it 'trial should be false' do
          expect(company.trial).to be_falsey
        end
        it 'stripe_plan should not be nil' do
          expect(company.stripe_plan).not_to be_nil
          expect(company.stripe_plan).to eq('free')
        end
        it 'stripe_subscription_id should not be nil' do
          expect(@subscription_id_after_first_conversion).not_to be_nil
        end
        it 'initial_conversion_date should be within 1 minute of now' do
          expect(company.initial_conversion_date).to be_within(1.minute).of(Time.zone.now)
        end

        describe 'plan change' do
          before :each do
            add_card_for_stripe_customer(company)
          end

          it 'subscription_id should stay the same' do
            company.apply_subscription(:basic)
            expect(company.stripe_subscription_id).to eq(@subscription_id_after_first_conversion)
          end

          it 'stripe_plan should reflect the new plan' do
            company.apply_subscription(:basic)
            expect(company.stripe_plan).to eq('basic')
          end

          it 'should call save method on stripe subscription' do
            expect_any_instance_of(Stripe::Subscription).to receive(:save)
            company.apply_subscription(:basic)
          end
        end
      end
    end
  end
end

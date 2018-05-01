# == Schema Information
#
# Table name: stripe_event_logs
#
#  id               :integer          not null, primary key
#  customer_id      :string
#  livemode         :boolean          not null
#  data             :text
#  event_type       :string
#  request          :string
#  pending_webhooks :integer
#  event_id         :string
#  note             :string
#  processed        :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

require 'rails_helper'

RSpec.describe StripeEventLog, type: :model do
  let(:stripe_helper) { StripeMock.create_test_helper }
  before { StripeMock.start }
  after { StripeMock.stop }
  before :each do
    setup_stripe_plans
  end

  describe 'request_url' do
    it 'should return "#" when request is missing' do
      record = FactoryGirl.create(:stripe_event_log)
      expect(record.request_url).to eq('#')
    end

    it 'should return a string that includes request id if request is present' do
      record = FactoryGirl.create(:stripe_event_log, request: 'x_abswdfwef')
      expect(record.request_url).to include('x_abswdfwef')
    end
  end

  context 'customer id is not set' do
    before :each do
      @record = FactoryGirl.create(:stripe_event_log)
    end

    it 'customer_url should return "#"' do
      expect(@record.customer_url).to eq('#')
    end

    it 'company should return nil' do
      expect(@record.company).to be_nil
    end

    it 'company_id should return nil' do
      record = FactoryGirl.create(:stripe_event_log)
      expect(record.company_id).to be_nil
    end
  end

  context 'customer_id is set' do
    before :each do
      @company = FactoryGirl.create(:company)
      @record = FactoryGirl.create(:stripe_event_log, customer_id: @company.stripe_customer_id)
    end

    it 'company stripe_customer_id should be present' do
      expect(@company.stripe_customer_id).to be_present
    end

    it 'company should return the company whose stripe_customer_id matches' do
      expect(@record.company.id).to eq(@company.id)
    end

    it 'company_id should return the company id whose stripe_customer_id matches' do
      expect(@record.company_id).to eq(@company.id)
    end

    it 'customer_url should return a string that includes customer id' do
      expect(@record.customer_url).to include(@company.stripe_customer_id)
    end
  end

  describe 'self.create_from_webhook' do
    it 'should raise error if webhook data not in the righ format' do
      expect { StripeEventLog.create_from_webhook({}) }.to raise_error(ArgumentError)
    end
  end

  describe 'after creation' do
    before :each do
      @log = FactoryGirl.build :stripe_event_log
    end

    it 'should call apply_webhook after creation' do
      expect(@log).to receive(:apply_webhook)
      @log.save
    end

    it 'should set processed == true' do
      @log.save
      expect(@log.reload.processed?).to be_truthy
    end
  end
end

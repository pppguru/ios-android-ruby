# == Schema Information
#
# Table name: companies
#
#  id                           :integer          not null, primary key
#  name                         :string(255)      not null
#  website                      :string(250)
#  length_of_appointment        :string(250)
#  total_doctors                :string(250)
#  number_of_operatories        :string(250)
#  about                        :text
#  digital_xray                 :string(100)
#  other_benefits               :string(250)
#  company_established          :string(250)
#  video_link                   :string(100)
#  employer_user_id             :integer
#  contact_name                 :string(200)
#  contact_email                :string(255)
#  contact_number               :string(255)
#  contact_private_number       :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  email                        :string
#  stripe_customer_id           :string
#  stripe_subscription_id       :string
#  stripe_plan                  :string
#  active                       :boolean          default(TRUE), not null
#  trial                        :boolean          default(TRUE), not null
#  trial_expiration             :datetime
#  initial_conversion_date      :datetime
#  pending_deactivation         :boolean          default(FALSE), not null
#  trial_expired_reminder_sent  :datetime
#  trial_expiring_reminder_sent :datetime
#  affiliation_id               :integer
#  anonymous_company            :boolean          default(FALSE), not null
#  anonymous_contact            :boolean          default(FALSE), not null
#  subscription_expiration      :datetime
#

require 'rails_helper'

RSpec.describe Company, type: :model do
  include ActiveJob::TestHelper

  it { should belong_to(:affiliation) }
  it { should have_many(:users) }
  it { should have_many(:job_postings) }

  let(:stripe_helper) { StripeMock.create_test_helper }
  before { StripeMock.start }
  after { StripeMock.stop }
  after { clear_enqueued_jobs }

  before :each do
    setup_stripe_plans
  end

  describe 'scopes' do
    describe 'eligible_for_trial_expiring_reminder' do
      shared_examples 'should not be eligible' do
        it 'should not include company' do
          expect(Company.eligible_for_trial_expiring_reminder).not_to include(company)
        end
      end

      shared_examples 'should be eligible' do
        it 'should include company' do
          expect(Company.eligible_for_trial_expiring_reminder).to include(company)
        end
      end

      context 'company is inactive' do
        it_behaves_like 'should not be eligible' do
          let(:company) { FactoryGirl.create(:company, active: false, trial: true) }
        end
      end

      context 'company is not on trial' do
        it_behaves_like 'should not be eligible' do
          let(:company) { FactoryGirl.create(:company, trial: false) }
        end
      end

      context 'company is on trial' do
        context 'trial has not expired' do
          context 'trial is expiring in 6 days' do
            context 'company has already received email' do
              it_behaves_like 'should not be eligible' do
                let(:company) do
                  FactoryGirl.create(:company, trial: true,
                                               trial_expiring_reminder_sent: 1.day.ago,
                                               trial_expiration: 6.days.from_now)
                end
              end
            end
            context 'company has not already received email' do
              let(:company) do
                FactoryGirl.create(:company, trial: true,
                                             trial_expiration: 6.days.from_now,
                                             trial_expiring_reminder_sent: nil)
              end
            end
          end
          context 'trial is expiring in 10 days' do
            context 'company has not already received email' do
              it_behaves_like 'should not be eligible' do
                let(:company) do
                  FactoryGirl.create(:company, trial: true,
                                               trial_expiring_reminder_sent: nil,
                                               trial_expiration: 10.days.from_now)
                end
              end
            end
          end
        end

        context 'trial has expired' do
          context 'company has already received email' do
            it_behaves_like 'should not be eligible' do
              let(:company) do
                FactoryGirl.create(:company, trial: true,
                                             trial_expiration: 10.days.ago,
                                             trial_expiring_reminder_sent: 3.days.ago)
              end
            end
          end

          context 'company has not received email' do
            it_behaves_like 'should not be eligible' do
              let(:company) do
                FactoryGirl.create(:company, trial: true,
                                             trial_expiration: 10.days.ago,
                                             trial_expiring_reminder_sent: nil)
              end
            end
          end
        end
      end
    end

    describe 'eligible_for_trial_reminder' do
      shared_examples 'should not be eligible' do
        it 'should not include company' do
          expect(Company.eligible_for_trial_reminder).not_to include(company)
        end
      end

      shared_examples 'should be eligible' do
        it 'should include company' do
          expect(Company.eligible_for_trial_reminder).to include(company)
        end
      end

      context 'company is inactive' do
        it_behaves_like 'should not be eligible' do
          let(:company) { FactoryGirl.create(:company, active: false, trial: true) }
        end
      end

      context 'company is not on trial' do
        it_behaves_like 'should not be eligible' do
          let(:company) { FactoryGirl.create(:company, trial: false) }
        end
      end

      context 'company is on trial' do
        context 'trial has not expired' do
          it_behaves_like 'should not be eligible' do
            let(:company) do
              FactoryGirl.create(:company, trial: true,
                                           trial_expiration: 10.days.from_now)
            end
          end
        end

        context 'trial has expired' do
          context 'company has already received email' do
            it_behaves_like 'should not be eligible' do
              let(:company) do
                FactoryGirl.create(:company, trial: true,
                                             trial_expiration: 10.days.ago,
                                             trial_expired_reminder_sent: 3.days.ago)
              end
            end
          end

          context 'company has not received email' do
            let(:company) do
              FactoryGirl.create(:company, trial: true,
                                           trial_expiration: 10.days.ago,
                                           trial_expired_reminder_sent: nil)
            end
          end
        end
      end

      context 'company is active' do
        context 'trial has expired but did not receive email' do
          it_behaves_like 'should be eligible' do
            let(:company) do
              FactoryGirl.create(:company, active: true, trial: true,
                                           trial_expiration: Time.zone.yesterday,
                                           trial_expired_reminder_sent: nil)
            end
          end
        end
      end
    end
  end

  describe 'creating a new account' do
    it 'active should default to true if not set' do
      company = FactoryGirl.create(:company)
      expect(company.active?).to be(true)
    end

    it 'should default to trial that expires 30 days from now if not set' do
      company = FactoryGirl.create(:company)
      expect(company.trial?).to be(true)
      expect(company.trial_expiration).not_to be(nil)
      expect(company.trial_expiration.to_date).to eq(14.days.from_now.to_date)
    end

    it 'should not set trial_expiration if trial is false upon creation' do
      company = FactoryGirl.create(:company, name: 'Test', trial: false, trial_expiration: nil)
      expect(company.trial_expiration).to be_nil
    end
  end

  describe 'deactivate!' do
    let(:company) { FactoryGirl.create(:company) }
    before :each do
      add_card_for_stripe_customer(company)
      company.apply_subscription :basic
      company.deactivate!
    end

    it 'sets stripe_plan to nil' do
      expect(company.stripe_plan).to be_nil
    end

    it 'sets stripe_subscription_id to nil' do
      expect(company.stripe_subscription_id).to be_nil
    end

    it 'sets pending_deactivation to false' do
      expect(company.pending_deactivation).to be_falsey
    end

    it 'sets active to false' do
      expect(company.active).to be_falsey
    end
  end

  describe 'trial_expired?' do
    it 'should return true if trial_expiration is not in the future' do
      company = FactoryGirl.create(:company, trial: true)
      company.trial_expiration = 3.days.ago
      expect(company.trial_expired?).to be(true)
    end

    it 'should return false if trial is false' do
      company = FactoryGirl.create(:company, trial: false, trial_expiration: 3.days.ago)
      expect(company.trial_expired?).to be(false)
    end

    it 'should return false if trial_expiration is in the future' do
      company = FactoryGirl.create(:company, trial: true)
      company.trial_expiration = 3.days.from_now
      expect(company.trial_expired?).to be(false)
    end
  end

  describe 'stripe actions after creation' do
    let(:company) { FactoryGirl.create(:company, name: 'Test company', email: 'test@email.com') }

    it 'Should get a stripe customer id' do
      expect(company.stripe_customer_id).not_to be_nil
    end
  end

  # describe 'mailer actions after creation' do
  #   it 'should queue a welcome email' do
  #     expect(enqueued_jobs.size).to eq(0)
  #     FactoryGirl.create(:company)
  #     expect(enqueued_jobs.size).to eq(1)
  #   end
  # end

  describe 'Account Status' do
    before :each do
      @company = FactoryGirl.create(:company)
    end

    it 'account status should return a string' do
      expect(@company.account_status).to be_a(String)
    end

    it 'return "Cancelled" under the correct conditions' do
      @company.update(stripe_plan: nil,
                      pending_deactivation: false,
                      active: false,
                      trial: false,
                      trial_expiration: nil)
      expect(@company.reload.account_status).to eq('Cancelled')
    end

    it 'return "Trial Expired" under the correct conditions' do
      @company.update(trial: true, trial_expiration: 2.days.ago)
      expect(@company.reload.account_status).to eq('Trial Expired')
    end

    it 'return "Subscribed" under the correct conditions' do
      @company.update(stripe_subscription_id: 'abcdefrg', trial: false)
      expect(@company.reload.account_status).to eq('Subscribed')
    end
  end
end

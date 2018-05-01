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

FactoryGirl.define do
  factory :company do
    name 'Test Company'
    email 'me@company.com'
  end
end

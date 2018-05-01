# == Schema Information
#
# Table name: users
#
#  id                         :integer          not null, primary key
#  name                       :string(100)
#  contact_name               :string(250)
#  email                      :string(100)      not null
#  phone                      :string(255)
#  photo                      :string(100)
#  role                       :string(20)
#  tagline                    :text
#  salary_configuration_id    :integer
#  notes                      :text
#  stripe_customer_id         :string(50)
#  location_range             :string(20)
#  virtual_interview          :integer
#  new_practice               :string(250)
#  new_practice_software      :string(250)
#  compensation_type          :string(20)
#  years_experience           :string(20)
#  work_availability          :string(30)
#  available_for_work_on      :date
#  user_name                  :string(100)
#  token                      :string(200)
#  token_expiration           :datetime
#  email_token                :string(250)
#  email_verified             :string(100)
#  email_expiration           :datetime
#  user_type                  :string(100)
#  new_email                  :string(100)
#  previous_emails            :string(300)
#  languages                  :string
#  created_at                 :datetime
#  updated_at                 :datetime
#  encrypted_password         :string           default(""), not null
#  reset_password_token       :string
#  reset_password_sent_at     :datetime
#  remember_created_at        :datetime
#  sign_in_count              :integer          default(0), not null
#  current_sign_in_at         :datetime
#  last_sign_in_at            :datetime
#  current_sign_in_ip         :inet
#  last_sign_in_ip            :inet
#  confirmation_token         :string
#  confirmed_at               :datetime
#  confirmation_sent_at       :datetime
#  unconfirmed_email          :string
#  provider                   :string
#  uid                        :string
#  affiliation_id             :integer
#  blocked_access             :boolean          default(FALSE), not null
#  accepted_terms             :boolean          default(FALSE), not null
#  active                     :boolean          default(TRUE), not null
#  alerts                     :boolean          default(FALSE), not null
#  last_company_context_id    :integer
#  profile_photo_file_name    :string
#  profile_photo_content_type :string
#  profile_photo_file_size    :integer
#  profile_photo_updated_at   :datetime
#

FactoryGirl.define do
  factory :user do
    sequence :email do |n|
      "test#{n}@test.com"
    end
    password 'testpass1234'
    name 'Swiss Monkey'
    confirmed_at Time.zone.now
  end
end

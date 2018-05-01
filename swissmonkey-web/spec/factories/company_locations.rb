# == Schema Information
#
# Table name: company_locations
#
#  id            :integer          not null, primary key
#  address_line1 :string(250)      not null
#  address_line2 :string(250)
#  city          :string(200)      not null
#  state         :string(250)      not null
#  zip_code      :string(100)      not null
#  company_id    :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#  country       :string
#

FactoryGirl.define do
  factory :company_location do
    address_line1 '123 Main St'
    city 'Sacramento'
    state 'CA'
    zip_code '95811'
  end
end

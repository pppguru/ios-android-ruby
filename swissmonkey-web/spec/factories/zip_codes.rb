# == Schema Information
#
# Table name: zip_codes
#
#  id         :integer          not null, primary key
#  longitude  :float
#  latitude   :float            not null
#  zip_code   :string(10)       not null
#  city       :string(100)      not null
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :zip_code do
  end
end

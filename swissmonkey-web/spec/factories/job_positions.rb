# == Schema Information
#
# Table name: job_positions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  sort_order :integer
#  created_at :datetime
#  updated_at :datetime
#

FactoryGirl.define do
  factory :job_position do
  end
end

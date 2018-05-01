# == Schema Information
#
# Table name: users_job_types
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  job_type   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

FactoryGirl.define do
  factory :users_job_type do
    user_id 1
    job_type 'MyString'
  end
end

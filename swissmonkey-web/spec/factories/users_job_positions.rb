# == Schema Information
#
# Table name: users_job_positions
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  job_position_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

FactoryGirl.define do
  factory :users_job_position do
    user_id 1
    job_position_id 1
  end
end

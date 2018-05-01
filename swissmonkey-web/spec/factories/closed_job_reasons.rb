# == Schema Information
#
# Table name: closed_job_reasons
#
#  id          :integer          not null, primary key
#  reason      :string(250)      not null
#  description :string(250)      not null
#  status      :string(250)      not null
#  created_at  :datetime
#  updated_at  :datetime
#  private     :boolean          default(FALSE), not null
#

FactoryGirl.define do
  factory :closed_job_reason do
    reason 'Test'
    description 'Test description'
    status 'Test'
  end
end

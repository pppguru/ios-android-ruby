# == Schema Information
#
# Table name: job_postings
#
#  id                            :integer          not null, primary key
#  job_position_id               :integer
#  job_description               :text
#  closed_job_reason_id          :integer
#  skype_interview               :string(100)      default("No"), not null
#  company_id                    :integer
#  logo                          :string(250)
#  company_location_id           :integer
#  compensation_type             :string(20)
#  publication_status            :string(20)
#  years_experience              :string(20)
#  job_type                      :string(30)
#  payment_type                  :string(20)
#  fill_by                       :date
#  languages                     :string
#  created_at                    :datetime
#  updated_at                    :datetime
#  require_photo                 :boolean          default(FALSE), not null
#  require_video                 :boolean          default(FALSE), not null
#  compensation_range_low        :decimal(11, 2)
#  compensation_range_high       :decimal(11, 2)
#  expiration                    :datetime
#  custom_practice_software      :string
#  require_resume                :boolean          default(FALSE), not null
#  require_recommendation_letter :boolean          default(FALSE), not null
#

require 'rails_helper'

RSpec.describe JobPosting, type: :model do
  it { should belong_to(:company) }
end

# == Schema Information
#
# Table name: job_postings_shift_configurations
#
#  id                     :integer          not null, primary key
#  job_posting_id         :integer          not null
#  shift_configuration_id :integer
#  created_at             :datetime
#  updated_at             :datetime
#

# Many-to-many join between JobPosting and ShiftConfiguration
class JobPostingsShiftConfiguration < ApplicationRecord
  belongs_to :job_posting
  belongs_to :shift_configuration
end

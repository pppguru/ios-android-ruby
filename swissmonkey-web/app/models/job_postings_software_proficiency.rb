# == Schema Information
#
# Table name: job_postings_software_proficiencies
#
#  job_posting_id          :integer          not null
#  software_proficiency_id :integer          not null
#

# Many-to-many join between JobPosting and SoftwareProficiency
class JobPostingsSoftwareProficiency < ApplicationRecord
  belongs_to :job_posting
  belongs_to :software_proficiency
end

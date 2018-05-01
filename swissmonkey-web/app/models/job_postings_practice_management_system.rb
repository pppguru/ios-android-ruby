# == Schema Information
#
# Table name: job_postings_practice_management_systems
#
#  job_posting_id                :integer          not null
#  practice_management_system_id :integer          not null
#

# Many-to-many join between JobPosting and PracticeManagementSystem
class JobPostingsPracticeManagementSystem < ApplicationRecord
  belongs_to :job_posting
  belongs_to :practice_management_system
end

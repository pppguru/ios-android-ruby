# == Schema Information
#
# Table name: job_applications
#
#  id                 :integer          not null, primary key
#  user_id            :integer          not null
#  job_posting_id     :integer          not null
#  application_status :string(30)
#  created_at         :datetime
#  updated_at         :datetime
#  employer_viewed    :boolean          default(FALSE), not null
#

# Represents a User-to-JobPosting mapping when a user applies
class JobApplication < ApplicationRecord
  belongs_to :user
  belongs_to :job_posting

  scope :by_company, lambda { |company_id|
    joins(:job_postings)
      .joins(:users)
      .where('job_postings.company_id = ?', company_id)
  }
  scope :by_job_posting, ->(job_posting_id) { where job_posting_id: job_posting_id }
  scope :by_application_status, ->(application_status) { where application_status: application_status }

  def applicant_hash
    hash = base_applicant_hash

    hash[:user_status] = 'blocked' if user.blocked_access?

    hash
  end

  private

  def base_applicant_hash
    {
      id: user_id,
      user: user,
      experience: user&.years_experience_label,
      viewed: employer_viewed?,
      application_status: application_status&.titleize,
      profile: user&.profile_pic,
      salary: user&.salary_configuration&.label,
      resume_files: user&.resumes || []
    }
  end
end

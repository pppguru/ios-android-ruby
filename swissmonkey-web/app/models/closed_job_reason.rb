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

# When a job is closed out this is the reason given
class ClosedJobReason < ApplicationRecord
  has_many :job_postings, dependent: :nullify

  scope :universal, -> { where private: false }
  scope :hidden, -> { where private: true }
end

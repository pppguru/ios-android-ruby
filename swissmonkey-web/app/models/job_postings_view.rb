# == Schema Information
#
# Table name: job_postings_views
#
#  id             :integer          not null, primary key
#  job_posting_id :integer          not null
#  user_id        :integer          not null
#  view_time      :datetime         not null
#  created_at     :datetime
#  updated_at     :datetime
#

# Log of someone viewing a job posting
class JobPostingsView < ApplicationRecord
  belongs_to :job_posting
  belongs_to :user
end

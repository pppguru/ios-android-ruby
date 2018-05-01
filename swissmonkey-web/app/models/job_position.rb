# == Schema Information
#
# Table name: job_positions
#
#  id         :integer          not null, primary key
#  name       :string(255)
#  sort_order :integer
#  created_at :datetime
#  updated_at :datetime
#

# The position that a job is for
class JobPosition < ApplicationRecord
  has_many :job_postings, dependent: :nullify
  has_many :users_job_positions, dependent: :destroy
  has_many :users, through: :users_job_positions, dependent: :nullify
end

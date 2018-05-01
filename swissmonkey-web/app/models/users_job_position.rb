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

# Join table that maps users to job postings
class UsersJobPosition < ApplicationRecord
  belongs_to :user
  belongs_to :job_position
end

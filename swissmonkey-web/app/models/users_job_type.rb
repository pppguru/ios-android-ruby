# == Schema Information
#
# Table name: users_job_types
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  job_type   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Maps users to job types (full time, part time, etc)
class UsersJobType < ApplicationRecord
  belongs_to :user
end

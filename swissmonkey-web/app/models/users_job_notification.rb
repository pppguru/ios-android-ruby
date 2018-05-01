# == Schema Information
#
# Table name: users_job_notifications
#
#  id                       :integer          not null, primary key
#  job_posting_id           :integer          not null
#  user_id                  :integer          not null
#  notification_description :string(250)      not null
#  viewed                   :string(100)      not null
#  created_at               :datetime
#  updated_at               :datetime
#

# Many-to-many join between User and JobNotification
class UsersJobNotification < ApplicationRecord
  belongs_to :user
  belongs_to :job_posting
end

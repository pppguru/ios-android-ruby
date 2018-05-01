# == Schema Information
#
# Table name: users_practice_management_systems
#
#  user_id                       :integer          not null
#  practice_management_system_id :integer          not null
#

# Many to many join between User and PracticeManagementSystem
class UsersPracticeManagementSystem < ApplicationRecord
  belongs_to :user
  belongs_to :practice_management_system
end

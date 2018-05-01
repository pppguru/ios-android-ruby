# == Schema Information
#
# Table name: users_software_proficiencies
#
#  user_id                 :integer          not null
#  software_proficiency_id :integer          not null
#

# Many-to-many join between User and SoftwareProficiency
class UsersSoftwareProficiency < ApplicationRecord
  belongs_to :user
  belongs_to :software_proficiency
end

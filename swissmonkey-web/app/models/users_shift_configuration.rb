# == Schema Information
#
# Table name: users_shift_configurations
#
#  shift_configuration_id :integer          not null, primary key
#  user_id                :integer          not null
#  created_at             :datetime
#  updated_at             :datetime
#

# Many-to-many join between User and ShiftConfiguration
class UsersShiftConfiguration < ApplicationRecord
  belongs_to :user
  belongs_to :shift_configuration
end

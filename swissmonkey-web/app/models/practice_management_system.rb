# == Schema Information
#
# Table name: practice_management_systems
#
#  id             :integer          not null, primary key
#  software       :string(250)
#  status         :string(1)
#  visible_to     :string(200)      default("all"), not null
#  software_value :string(100)
#  created_at     :datetime
#  updated_at     :datetime
#

# Represents a software used to manage a dental practice
class PracticeManagementSystem < ApplicationRecord
  scope :not_other, -> { where 'software != ?', 'Other' }
  scope :visible_to, ->(ids) { where visible_to: ids }
end

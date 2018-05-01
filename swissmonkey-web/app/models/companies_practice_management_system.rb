# == Schema Information
#
# Table name: companies_practice_management_systems
#
#  company_id                    :integer          not null
#  practice_management_system_id :integer          not null
#

# Many-to-many join between Company and PracticeManagementSystem
class CompaniesPracticeManagementSystem < ApplicationRecord
  belongs_to :company
  belongs_to :practice_management_system
end

# == Schema Information
#
# Table name: employee_benefits
#
#  id                      :integer          not null, primary key
#  name                    :string(250)      not null
#  predefined_benefit_list :string(100)      not null
#  created_at              :datetime
#  updated_at              :datetime
#

# Benefit plan
class EmployeeBenefit < ApplicationRecord
end

# == Schema Information
#
# Table name: companies_employee_benefits
#
#  company_id          :integer          not null
#  employee_benefit_id :integer          not null
#

# Attaches job benefits to a company
class CompaniesEmployeeBenefit < ApplicationRecord
  belongs_to :company
  belongs_to :employee_benefit
end

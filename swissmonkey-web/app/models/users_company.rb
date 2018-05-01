# == Schema Information
#
# Table name: users_companies
#
#  user_id    :integer          not null
#  company_id :integer          not null
#  blocked    :boolean          default(FALSE), not null
#

# Many-to-many join between User and Company
class UsersCompany < ApplicationRecord
  belongs_to :company
  belongs_to :user
end

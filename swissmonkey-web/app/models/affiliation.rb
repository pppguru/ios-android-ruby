# == Schema Information
#
# Table name: affiliations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

# Represents an organization that users and companies belong to
class Affiliation < ApplicationRecord
  has_many :companies, dependent: :nullify
  has_many :users, dependent: :nullify
end

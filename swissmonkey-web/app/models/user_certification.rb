# == Schema Information
#
# Table name: user_certifications
#
#  id                      :integer          not null, primary key
#  user_id                 :integer          not null
#  license_number          :string(200)
#  license_expiry          :date
#  license_verified_states :string(250)
#  created_at              :datetime
#  updated_at              :datetime
#  certified_by_board      :boolean          default(FALSE)
#  license_verified        :boolean          default(FALSE), not null
#

# Represents a license certification for a job seeker
class UserCertification < ApplicationRecord
  belongs_to :user
end

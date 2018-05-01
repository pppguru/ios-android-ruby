# == Schema Information
#
# Table name: company_locations
#
#  id            :integer          not null, primary key
#  address_line1 :string(250)      not null
#  address_line2 :string(250)
#  city          :string(200)      not null
#  state         :string(250)      not null
#  zip_code      :string(100)      not null
#  company_id    :integer          not null
#  created_at    :datetime
#  updated_at    :datetime
#  country       :string
#

# An address that belongs to a company
class CompanyLocation < ApplicationRecord
  include AddressFormatting

  belongs_to :company
  has_many :job_postings, dependent: :nullify

  def coordinates
    company_lat_long = ZipCode.find_by zip_code: zip_code
    return unless company_lat_long
    {
      latitude: company_lat_long.latitude,
      longitude: company_lat_long.longitude
    }
  end
end

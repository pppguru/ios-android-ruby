# == Schema Information
#
# Table name: zip_codes
#
#  id         :integer          not null, primary key
#  longitude  :float
#  latitude   :float            not null
#  zip_code   :string(10)       not null
#  city       :string(100)      not null
#  created_at :datetime
#  updated_at :datetime
#

# This is where we store geocoded zip code data
class ZipCode < ApplicationRecord
  def coordinates?
    longitude.present? && latitude.present?
  end

  def geocoder_format
    {
      city: city,
      latitude: latitude,
      longitude: longitude
    }
  end
end

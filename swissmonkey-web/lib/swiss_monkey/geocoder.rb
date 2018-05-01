module SwissMonkey
  # Interfaces with Google geocoder
  class Geocoder
    def self.get_coordinates(address)
      address.delete!(' ')
      is_zip_code = !(address =~ /^\d{5}(-\d{4})?$/).nil?

      if is_zip_code
        rec = ZipCode.find_by zip_code: address

        return rec.geocoder_format if rec.present?
      end

      geo = Geokit::Geocoders::MultiGeocoder.geocode(address)
      return unless geo.success

      create_zip_from_geo(address, geo) if is_zip_code

      {
        city: geo.city,
        latitude: geo.lat,
        longitude: geo.lng
      }
    end

    def self.create_zip_from_geo(zip, geo)
      zip_code = ZipCode.find_or_initialize_by zip_code: zip.first(5)
      zip_code.latitude = geo.lat
      zip_code.longitude = geo.lng
      zip_code.city = geo.city
      zip_code.save!
    end
  end
end

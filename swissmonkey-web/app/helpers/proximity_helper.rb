require 'geokit'

# Helps with distance calculations
module ProximityHelper
  def distance(from_lat, from_long, to_lat, to_long)
    current_location = Geokit::LatLng.new(from_lat, from_long)
    destination = "#{to_lat},#{to_long}"
    current_location.distance_to(destination)
  end

  def distance_from_hash(from, to)
    distance(from[:latitude], from[:longitude], to[:latitude], to[:longitude])
  end
end

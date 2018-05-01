# Commonality shared between Address and CompanyLocation
module AddressFormatting
  extend ActiveSupport::Concern

  def to_s
    lines = []
    lines << address_line1
    lines << address_line2 if address_line2.present?
    lines << csz
    lines << safe_country

    lines.join("\n")
  end

  def csz
    format('%s, %s %s', city, state, zip_code)
  end

  def safe_country
    country if country.present? && country != 'USA'
  end

  def select_label
    address_line1 + ', ' + city
  end

  def coordinates; end
end

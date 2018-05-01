# == Schema Information
#
# Table name: addresses
#
#  id            :integer          not null, primary key
#  user_id       :integer          not null
#  address_line1 :string(100)
#  address_line2 :string(200)
#  city          :string(200)
#  state         :string(200)
#  zip_code      :string(100)      not null
#  country       :string(100)
#  created_at    :datetime
#  updated_at    :datetime
#

# Represents a physical address for a user
class Address < ApplicationRecord
  include AddressFormatting

  belongs_to :user
end

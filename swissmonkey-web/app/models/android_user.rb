# == Schema Information
#
# Table name: android_users
#
#  id         :integer          not null, primary key
#  email      :string(100)
#  created_at :datetime
#  updated_at :datetime
#

# Registered android user
class AndroidUser < ApplicationRecord
end

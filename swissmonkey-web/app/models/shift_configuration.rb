# == Schema Information
#
# Table name: shift_configurations
#
#  id         :integer          not null, primary key
#  shift_days :string(255)
#  shift_time :string(255)      not null
#

# Represents a shift availability schedule
class ShiftConfiguration < ApplicationRecord
  include LegacyHelper

  def shift_id
    shift_time_to_id(shift_time)
  end
end

# == Schema Information
#
# Table name: salary_configurations
#
#  id           :integer          not null, primary key
#  salary_name  :string(100)
#  salary_value :string(100)
#  status       :string(1)
#  created_at   :datetime
#  updated_at   :datetime
#  range_high   :decimal(11, 2)
#  range_low    :decimal(11, 2)
#

# A user is attached to a Salary Configuration.  This represents the salary range they seek
class SalaryConfiguration < ApplicationRecord
  include ActionView::Helpers::NumberHelper

  def appropriate_for_job?(job)
    if job.compensation_range_high && job.compensation_range_low && range_high &&
       range_high <= job.compensation_range_high
      true
    else
      false
    end
  end

  def label
    if range_high
      "#{number_to_currency(range_low)} - #{number_to_currency(range_high)}"
    else
      salary_value
    end
  end
end

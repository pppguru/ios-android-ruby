# Fixed lists of data
module EnumerationsHelper
  def years_experience_enum
    {
      'LESS_THAN_1' => 'Less than 1',
      'YEARS_1' => '1 Year',
      'YEARS_2' => '2 Years',
      'YEARS_3' => '3 Years',
      'YEARS_4' => '4 Years',
      'YEARS_5' => '5 Years',
      'YEARS_6' => '6 Years',
      'YEARS_7' => '7 Years',
      'YEARS_8' => '8 Years',
      'YEARS_9' => '9 Years',
      'YEARS_10_PLUS' => '10+ Years'
    }
  end

  def shift_times_enum
    {
      'MORNING' => 'Morning',
      'AFTERNOON' => 'Afternoon',
      'EVENING' => 'Evening'
    }
  end

  def compensation_types_enum
    {
      'DAILY' => 'Daily',
      'SALARY' => 'Salary',
      'HOURLY' => 'Hourly',
      'OTHER' => 'Other'
    }
  end

  def boolean_selections_enum
    {
      true => 'Yes',
      false => 'No'
    }
  end

  def job_types_enum
    {
      'FULL_TIME' => 'Full-time',
      'EXTERNSHIP' => 'Externship',
      'PART_TIME' => 'Part-time',
      'DAILY' => 'Daily',
      'TEMP' => 'Temporary',
      'TEMP_IMMEDIATE' => 'Temp - Immediate (needed within 24 hours)',
      'OTHER' => 'Other'
    }
  end

  def shift_description(key)
    case key
    when 'MORNING'
      '7 - 12PM'
    when 'AFTERNOON'
      '12 - 5PM'
    when 'EVENING'
      '5 - 7PM'
    end
  end

  def days_of_week
    %w[Sunday Monday Tuesday Wednesday Thursday Friday Saturday]
  end
end

# Translate data from legacy formats
module LegacyHelper
  def miles_range_to_numeric(miles_range)
    legacy_data_item('miles_range_numeric', miles_range)
  end

  def miles_range_id_to_enum(miles_range_id)
    legacy_data_item('miles_range', miles_range_id&.to_i)
  end

  def years_experience_to_numeric(years_experience)
    legacy_data_item('years_experience_reverse', years_experience)
  end

  def years_experience_from_numeric(years_experience)
    legacy_data_item('years_experience', years_experience&.to_i)
  end

  def years_experience_to_string(years_experience)
    legacy_data_item('years_experience_labels', years_experience)
  end

  def shift_id_to_time(shift_id)
    legacy_data_item('shifts', shift_id&.to_i)
  end

  def shift_time_to_id(shift_time)
    legacy_data_item('shifts_reverse', shift_time) || 'EVENING'
  end

  def compensation_id_to_enum(compensation_id)
    legacy_data_item('compensation', compensation_id&.to_i)
  end

  def job_type_id_to_enum(job_type_id)
    legacy_data_item('job_types', job_type_id&.to_i)
  end

  def work_availability_id_to_enum(work_availability_id)
    legacy_data_item('work_availability', work_availability_id&.to_i)
  end

  def legacy_data_item(key, id)
    return unless id
    LEGACY_DATA[key][id]
  end
end

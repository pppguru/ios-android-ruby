json.positions do
  json.array!(@positions) do |position|
    json.position_id position.id
    json.position_name position.name
    json.order_id position.sort_order
  end
end
json.location_range @location_range
json.experience @experiences
json.jobtype @job_types
json.comprange @compensations
json.shifts @shifts
json.software_proficiency do
  json.array!(@software_proficiency) do |proficiency|
    json.software_type_id proficiency.id
    json.software_type_name proficiency.name
    json.software_type_value proficiency.value
    json.status proficiency.status
    json.parent_id proficiency.parent_id
  end
end
json.praticeManagementSoftware do
  json.array!(@practice_management_software) do |software|
    json.software_id software.id
    json.software software.software
    json.status software.status
    json.visible_to software.visible_to
    json.software_value software.software_value
  end
end
json.work_availability @work_availability
json.state_list @state_list

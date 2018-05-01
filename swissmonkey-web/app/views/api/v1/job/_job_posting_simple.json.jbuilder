json.job_id job.id
json.company_id job.company_id

json.compensations job.compensation_label
json.company_logo job.company&.file_attachments&.profile_pics&.first&.url
json.compensation_amount job.compensation_amount_label
json.year_of_experience job.years_experience_label || '-'
json.job_type job.job_type_label || '-'

json.resume job.require_resume
json.letter_of_recommendation job.require_recommendation_letter
json.position job.job_position&.name
json.job_description job.job_description
json.fill_by job.fill_by&.to_formatted_s(:mysql_format)
json.practice_management_system job.practice_management_systems_names || '-'
json.status job.status_legacy
json.from_compensation_amount job.compensation_range_low
json.to_compensation_amount job.compensation_range_high
json.logo job.logo

json.about_your_company job.company&.about
json.website job.company&.display_website
json.company_name job.company&.display_name
json.company_email job.company&.contact_display_email
json.contact_name job.company&.contact_display_name
json.company_phoneno job.company&.contact_display_phone
json.company_established job.company&.company_established

json.total_no_of_doctors job.company&.total_doctors
json.total_no_of_operatories job.company&.number_of_operatories
json.length_of_appointment job.company&.length_of_appointment
json.video_link job.company&.video_link || '-'

json.digital_x_ray job.company&.display_digital_xray
json.benefits job.company&.benefits_list&.join(', ')
json.company_practice_management_system job.company&.practice_management_systems_list&.join(', ')

json.practicephotos job.company&.practice_photo_urls

json.skillsarray job.software_proficiencies.map(&:name)
json.languages job.languages

json.photo_required job.require_photo? ? 'Yes' : 'No'
json.video_required job.require_video? ? 'Yes' : 'No'
json.skype_interview job.skype_interview

json.shifts job.shift_configurations_legacy

json.job_location job.company_location_id
if job.company_location.present?
  if job.company&.anonymous?
    json.address1 'ANONYMOUS'
    json.address2 ''
  else
    json.address1 job.company_location&.address_line1
    json.address2 job.company_location&.address_line2
  end

  json.city job.company_location&.city
  json.state job.company_location&.state
  json.zipcode job.company_location&.zip_code

  company_coordinates = job.company_location&.coordinates
  if company_coordinates
    json.company_lat company_coordinates[:latitude]
    json.company_long company_coordinates[:longitude]
  end
end

json.skills job.skills_list.reject(&:blank?).join(', ')

json.statusName job.status_label

json.updated_at job.created_at_mysql_format

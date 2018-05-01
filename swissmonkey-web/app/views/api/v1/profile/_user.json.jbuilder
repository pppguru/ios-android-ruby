json.name user.name
json.phoneNumber user.phone
json.email user.email
json.positionID user.job_position&.id
json.positionIDs user.job_positions.map(&:id)
json.experienceID user.years_experience_numeric
json.newPracticeSoftware user.new_practice_software
json.practiceManagementID user.practice_management_systems.map(&:id)
json.aboutMe user.tagline
json.skills user.software_proficiencies.map(&:id)
json.shifts user.shift_configurations_legacy
json.bilingual_languages user.languages
json.job_types user.job_types

certification = user.user_certifications.first

if certification
  json.boardCretifiedID certification.certified_by_board? ? 1 : 0
  json.licenseNumber certification.license_number
  json.licenseVerified certification.license_verified? ? 1 : 0
end

resume_files = user.file_attachments.resumes
recommendation_letters = user.file_attachments.recommendation_letters

image_files = user.file_attachments.images
video_files = user.file_attachments.video

json.resume resume_files.map(&:filename)
json.resume_url resume_files.map(&:url)

json.profile user.profile_pic_filename
json.profile_url user.profile_pic

json.recomendationLettrs recommendation_letters.map(&:filename)
json.recomendationLettrs_url recommendation_letters.map(&:url)

json.image image_files.map(&:filename)
json.image_url image_files.map(&:url)
json.video video_files.map(&:filename)
json.video_url video_files.map(&:url)
# json.videoThumbnail []
json.locationRangeID user.location_range_numeric

address = user.addresses.first
if address
  json.addressLine1 address.address_line1
  json.addressLine2 address.address_line2
  json.city address.city
  json.state address.state
  json.zipcode address.zip_code
end

json.from_salary_range user.salary_configuration&.range_low
json.to_salary_range user.salary_configuration&.range_high
json.salary user.salary_configuration&.salary_value

json.partial! 'api/v1/profile/files', files: user.file_attachments

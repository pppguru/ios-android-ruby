# Profile-related helper methods
module ProfileHelper
  def determine_s3_object_ref
    filename = params[:file]
    type = params[:type]

    return render(json: nil) unless filename && type

    @s3_object_ref = s3_file_path(filename, type)

    head 404 unless @s3_object_ref
  end

  def setup_s3_bucket
    @s3 = Aws::S3::Resource.new(region: ENV['AWS_S3_REGION'])
    @s3_bucket = @s3.bucket(ENV['AWS_S3_BUCKET'])
  end

  def s3_file_exists?(file)
    object = @s3_bucket.object(file)
    object.exists?
  end

  def s3_file_path(filename, type)
    case type
    when 'imgFiles'
      'images/' + filename
    when 'recommendationletters'
      'recommendatioLetters/' + filename
    when 'profile'
      'profileimages/' + filename
    when 'resume'
      'resume/' + filename
    when 'videoFiles'
      'videos/' + filename
    end
  end

  def upload_profile_pic(upload)
    current_user.file_attachments.profile_pics.destroy_all
    current_user.profile_photo = upload
    current_user.save!
    current_user.profile_photo.url(:thumbnail)
  end

  def initialize_attachment(key)
    upload = params[key.strip]
    @type = 'recommendationLetters' if @type == 'recommendationletters'

    if @type == 'profile'
      upload_profile_pic(upload)
    else
      attachment = FileAttachment.create! attachment_type: @type,
                                          sort_order: 0,
                                          uses_paperclip: true,
                                          user_id: current_user.id,
                                          file: upload

      attachment.file.url
    end
  end

  def check_zip_code(zip_code)
    zip_record = ZipCode.find_by zip_code: zip_code

    return true if zip_record

    coordinates = SwissMonkey::Geocoder.get_coordinates(zip_code)
    return false unless coordinates

    zip_record = ZipCode.new
    zip_record.zip_code = zip_code
    zip_record.city = coordinates[:city]
    zip_record.latitude = coordinates[:latitude]
    zip_record.longitude = coordinates[:longitude]
    # begin
    zip_record.save!
    # rescue => ex
    #   Airbrake.notify ex
    #   respond_with_try_again
    #   return false
    # end

    true
  end

  def parse_save_params
    @name = params[:name]
    @new_email = params[:newEmail]
    @phone_number = params[:phoneNumber]

    parse_job_types_param
    parse_address_params
    parse_license_params
    parse_salary_params
    parse_proficiency_params
    parse_resume_params
  end

  def parse_availability_params
    @work_availability = params[:workAvailabilityID]
    @work_availability_date = params[:workAvailabilityDate]
  end

  def parse_resume_params
    @about_me = params[:aboutMe]
    @position = params[:positionID]
    @experience = params[:experienceID]
    @shifts = params[:shifts]
    @miles = params[:locationRangeID]
    @comments = params[:comments]
  end

  def parse_proficiency_params
    @practice_management_system = params[:practiceManagementID]
    @new_practice_software = params[:newPracticeSoftware]
    @additional_skills = params[:skills]
    @bilingual_languages = params[:bilingual_languages]
  end

  def parse_salary_params
    @compensation_id = params[:compensationID]
    @salary = params[:salary]
    @to_salary_range = params[:to_salary_range]
    @from_salary_range = params[:from_salary_range]
  end

  def parse_job_types_param
    @job_types = if params[:job_types].is_a?(Array)
                   params[:job_types]
                 elsif params[:job_types].blank?
                   nil
                 else
                   params[:job_types].split(',')
                 end
  end

  def parse_address_params
    @address_line1 = params[:addressLine1]
    @address_line2 = params[:addressLine2]
    @city = params[:city]
    @state = params[:state]
    @zip_code = params[:zipcode]&.gsub(/^(\d{5}).+$/, '\1')
  end

  def parse_license_params
    @board_certified = parse_bool_from_numeric(:boardCretifiedID)
    @license_number = params[:licenseNumber]
    @license_expiry = params[:licenseExpiry]
    @license_verified_states = params[:licenseVerifiedStates]
    @license_verified = params[:licenseVerified]
  end

  def process_upload_keys
    @keys = params[:keys]
    @keys = @keys.tr('()', '').tr("\n", ',').split(',').reject(&:blank?) unless @keys.is_a?(Array)
  end

  def delete_on_s3(file_path)
    object = @s3_bucket.object(file_path)
    object.delete
  end

  def delete_in_database(_type, filename)
    FileAttachment.where(user_id: current_user.id, file: filename).destroy_all
  end

  def parse_bool_from_numeric(param)
    params[param]&.to_s == '1'
  end
end

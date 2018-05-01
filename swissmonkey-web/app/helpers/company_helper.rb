# Used by the dashboard profile controller
module CompanyHelper
  private

  def update_company!
    @company.assign_attributes company_params
    @company.employer_user_id = current_user.id
    @company.video_link = @video_link
    @email ||= current_user.email
    @company.contact_email = @email
    @company.save!
  end

  def update_company_location!
    location = @company.company_locations.first || CompanyLocation.new
    location.assign_attributes(location_params)
    unless SwissMonkey::Geocoder.get_coordinates(location.zip_code)
      return respond_with_error('Invalid Zipcode')
    end
    location.save!
  end

  def location_params
    {
      address_line1: params[:address1],
      address_line2: params[:address2],
      city: params[:city],
      state: params[:state],
      company_id: @company_id,
      zip_code: params[:zipcode]
    }
  end

  def company_params
    basic_params
      .merge(contact_params)
      .merge(phone_params)
      .merge(anonymous_params)
  end

  def basic_params
    {
      company_established: params[:establishedDate],
      total_doctors: params[:totalDoctors],
      number_of_operatories: params[:totaloperatories],
      length_of_appointment: params[:appointmentLength],
      digital_xray: params[:xrays],
      about: params[:practiceDescription]
    }
  end

  def contact_params
    {
      name: params[:practicename],
      website: params[:url]
    }
  end

  def phone_params
    {
      contact_number: params[:phoneno].gsub('/[^0-9]+/', ''),
      contact_private_number: params[:private_number].gsub('/[^0-9]+/', '')
    }
  end

  def anonymous_params
    {
      anonymous_company: params[:company_name_anonymous] == 'true',
      anonymous_contact: params[:contact_name_anonymous] == 'true'
    }
  end

  def parse_update_params
    @video_link = params[:video_link]
    @custom_benefits = params[:custom_benefit]
    @name = params[:name]
    @email = params[:email]
    @newemail = params[:newemail]
  end

  def assign_practice_management_systems
    @new_practice_software = params[:new_practice_software]
    @practice_management_system_ids = params[:practiceSoftware] || []
    if @new_practice_software && @new_practice_software != ''
      new_ps = PracticeManagementSystem.create! software: @new_practice_software, visible_to: current_user.id
      @practice_management_system_ids << new_ps.id
    end
    @company.practice_management_systems = PracticeManagementSystem.where(id: @practice_management_system_ids)
  end

  def assign_company_benefits
    @benefits = params[:benefits]
    @company.employee_benefits = EmployeeBenefit.where(id: @benefits)
    @company.other_benefits = @custom_benefits
  end

  def process_email_change
    return unless @newemail
    previous_email = current_user.email
    check_new_email = User.find_by(new_email: @newemail)
    check_existing_mails = User.find_by(username: @newemail)

    if check_existing_mails || check_new_email # return "email exists"
      return respond_with_error('email exists')
    end

    current_user.update! new_email: @newemail

    UserMailer.change_mail(previous_email, @newemail).deliver_now!
  end
end

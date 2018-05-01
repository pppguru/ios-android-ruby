# Helper methods for job searches
module JobSearchHelper
  def validate_search_location
    @search_lat_long = nil
    return unless @search&.delete!(' ')
    @search_lat_long = SwissMonkey::Geocoder.get_coordinates(@search)
    return if @search_lat_long
    render json: { error: 'Enter correct location' }, status: 400
  end

  def parse_search_params
    @position = params[:position]
    @miles = params[:miles] || 40
    @search = params[:search]
    @experience = params[:experience]
    @shifts = params[:shifts]

    parse_job_type
    parse_compensation
  end

  def parse_job_type
    @job_type = params[:job_type]
    @job_type_criteria = @job_type
  end

  def parse_compensation
    @compensation_id = params[:compensation_id]
    @compensation_criteria = compensation_id_to_enum(@compensation_id)
    @from_compensation = params[:fromCompensation]
    @to_compensation = params[:toCompensation]
  end

  def build_job_search_query
    @jobs_query = JobPosting.includes(:job_position, :company).where(publication_status: 'PUBLISHED')
    filter_jobs_by_position
    filter_jobs_by_company
    filter_jobs_by_experience
    filter_jobs_by_type
    filter_jobs_by_compensation

    @jobs_query
  end

  def filter_jobs_by_compensation
    if @compensation_criteria.present?
      @jobs_query = @jobs_query.where('compensation_type IS NULL OR compensation_type = ?', @compensation_criteria)
    end

    if @from_compensation.present?
      @jobs_query = @jobs_query.where('compensation_range_low IS NULL OR compensation_range_low >= ?',
                                      @from_compensation)
    end

    return if @to_compensation.blank?
    @jobs_query = @jobs_query.where('compensation_range_high IS NULL OR compensation_range_high <= ?',
                                    @to_compensation)
  end

  def filter_jobs_by_type
    return if @job_type_criteria.blank?
    @jobs_query = @jobs_query.where('job_type IS NULL OR job_type IN (?)', @job_type_criteria)
  end

  def filter_jobs_by_experience
    return if @experience.blank?

    acceptable_values = LEGACY_DATA['years_experience'].select { |k, _v| k.to_i >= @experience.to_i }

    @jobs_query = @jobs_query.where('years_experience IS NULL OR years_experience IN (?)', acceptable_values.values)
  end

  def filter_jobs_by_company
    return unless @companies.present? && @companies.any?
    @jobs_query = @jobs_query.where('company_id NOT IN (?)', @companies)
  end

  def filter_jobs_by_position
    return unless @position && @position != 'All Jobs'
    @jobs_query = @jobs_query.where('job_position_id IN (?)', @position)
  end

  def job_within_distance?(job_posting)
    company_lat_long = nil
    company_location_details = CompanyLocation.find_by id: job_posting.company_location_id
    if company_location_details
      company_lat_long = ZipCode.find_by zip_code: company_location_details.zip_code
    end

    user_lat_long = if @search_lat_long
                      @search_lat_long
                    elsif @address
                      SwissMonkey::Geocoder.get_coordinates(@address.zip_code)
                    end

    return false unless company_lat_long && user_lat_long

    distance = distance(user_lat_long[:latitude], user_lat_long[:longitude],
                        company_lat_long.latitude, company_lat_long.longitude)
    distance <= @miles.to_f
  end

  def job_matches_shift_timing?(job_posting)
    return true unless @shifts.present? && @shifts.any?

    matches_times = true
    @shifts.each do |shift|
      shift_days = get_shift_configuration(job_posting, shift)

      if shift['days']
        matches_days = true
        # shift_days.each do |day|
        #   matches_days = false unless shift['days'] && shift['days'].include?(day)
        # end
        shift['days'].each do |day|
          matches_days = false unless shift_days.include?(day)
        end

        matches_times = false unless matches_days
      else
        matches_times = false
      end
    end

    matches_times
  end

  def job_eligible?(job_posting)
    !job_posting.expired? &&
      matches_experience?(job_posting) &&
      matches_practice_management_systems?(job_posting) &&
      current_user.addresses.first&.zip_code.present? &&
      eligible_by_distance?(job_posting)
  end
end

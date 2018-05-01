module Api
  module V1
    # Job endpoints
    class JobController < ::Api::V1Controller
      include LegacyHelper
      include ProximityHelper
      include JobApplicationHelper
      include JobSearchHelper
      include JobListHelper

      skip_before_action :validate_user_authentication, only: :search

      before_action :set_job, only: [:details]
      before_action :log_job_view, only: [:details]
      before_action :parse_search_params, only: %i[search jobs]
      before_action :validate_search_location, only: %i[search jobs]
      before_action :set_job_from_jobid, only: %i[save apply]
      before_action :initialize_application, only: :apply
      before_action :validate_job_open, only: %i[save apply]
      before_action :validate_not_blocked, only: %i[save apply]

      def details
        @compensation_amount = if @job.compensation_range?
                                 "#{@job.compensation_range_low}-$#{@job.compensation_range_high}"
                               else
                                 '(Not Specified)'
                               end

        @jobs = [@job]
      end

      def initialize_filters
        if user_signed_in?
          @address = current_user.addresses.first
          @companies = Company.excluded_from_search_results_for_user(current_user).map(&:id)
        else
          @address = nil
          @companies = nil # TODO: aren't there blacklisted companies even if the searcher is anonymous?
        end
      end

      def search
        jobs_result = []

        initialize_filters
        build_job_search_query

        @jobs_query.each do |job_posting|
          jobs_result << job_posting if job_matches_shift_timing?(job_posting)
        end

        jobs_result.select! do |job_posting|
          job_within_distance?(job_posting)
        end

        @jobs = jobs_result
      end

      def save
        job_application = JobApplication.find_or_initialize_by(
          user_id: current_user.id,
          job_posting_id: @job.id, application_status: 'SAVED'
        )

        if job_application.id.present?
          respond_with_error "You've already saved this job"
        else
          # begin
          job_application.save!
          respond_with_success 'Job saved successfully'
          # rescue
          #   respond_with_try_again
          # end
        end
      end

      def apply
        @job.send_new_application_text!

        data = current_user.application_hash.merge(
          position_name: @job.job_position&.name,
          profile_match: job_user_rank,
          job_apply_id: @application&.id
        )

        JobMailer.user_applied_for_job(@job.best_email, data).deliver_now!
        respond_with_success('Applied for job successfully')
        # rescue => ex
        #   respond_with_error(ex.message)
      end

      def job_user_rank
        SwissMonkey::UserJobRanking.new(@job.id, current_user.id).rank
      end

      def jobs
        initialize_job_list_query
        filter_out_excluded_companies

        @jobs = []
        @jobs_query.each do |job|
          @jobs << job if job_eligible?(job)
        end
      end

      def applications
        @applications = current_user.job_applications.where('application_status != ?', 'SAVED')
      end

      def savedjobs
        @applications = current_user.job_applications.where(application_status: 'SAVED')
      end

      def history
        @views = current_user.job_postings_views.order(view_time: :desc)
      end

      private

      def log_job_view
        return if current_user.blank? || @job.job_postings_views.find_by(user_id: current_user.id)
      rescue ActiveRecord::RecordNotFound
        @job.job_postings_views.create(user_id: current_user.id, view_time: Time.zone.now)
      end

      def set_job
        @job = JobPosting.find_by id: params[:id]

        render json: { error: 'JobId not found' }, status: 400 if @job.blank?
      end

      def set_job_from_jobid
        @job = JobPosting.find_by id: params[:jobID]

        respond_with_error('Job not found') unless @job
      end

      def validate_job_open
        respond_with_error('This job has been closed') unless @job.published?
      end

      def validate_not_blocked
        companies = Company.excluded_from_search_results_for_user(current_user).map(&:id)
        return unless companies.include? @job.company_id
        respond_with_success('You cannot save this job')
      end

      def get_shift_configuration(job_posting, shift)
        config = job_posting.shift_configurations.find_by(shift_time: shift_id_to_time(shift['shiftID']))

        (config&.shift_days || '').split(',')
      end

      def matches_practice_management_systems?(job_posting)
        job_software_ids = job_posting.practice_management_systems.map(&:id)
        user_software_ids = current_user.practice_management_systems.map(&:id)
        matching_software_ids = job_software_ids & user_software_ids
        matching_software_ids.length >= job_software_ids.length
      end

      def matches_experience?(job_posting)
        current_user.years_experience.blank? ||
          current_user.years_experience_numeric >= job_posting.years_experience_numeric
      end

      def eligible_by_distance?(job_posting)
        company_lat_long = determine_company_location(job_posting)
        user_lat_long = determine_user_location
        return true unless user_lat_long && company_lat_long

        distance = distance(user_lat_long[:latitude], user_lat_long[:longitude],
                            company_lat_long.latitude, company_lat_long.longitude)

        !distance || !preferred_miles || distance <= preferred_miles
      end

      def determine_company_location(job_posting)
        company_location_details = CompanyLocation.find_by id: job_posting.company_location_id
        return unless company_location_details
        ZipCode.find_by zip_code: company_location_details.zip_code
      end

      def determine_user_location
        if @search_lat_long
          @search_lat_long
        elsif @address
          SwissMonkey::Geocoder.get_coordinates(@address.zip_code)
        end
      end

      def preferred_miles
        current_user.location_range_numeric || 40
      end
    end
  end
end

require 'aws-sdk'

module Api
  module V1
    # Profile endpoints
    class ProfileController < ::Api::V1Controller
      include LegacyHelper
      include ProfileHelper

      before_action :setup_s3_bucket, only: %i[download upload delete]
      before_action :determine_s3_object_ref, only: [:download]
      before_action :parse_save_params, only: :save
      before_action :validate_location, only: :save
      before_action :check_video_count, only: :upload

      def save
        save_user_details
        save_address
        save_certification
        save_salary_configuration
        save_shift_configuration
        save_new_email
        save_practice_management
        save_additional_skills

        render json: { succes: 'Updated your profile successfully' }
        # rescue => ex
        #   Airbrake.notify ex
        #   respond_with_try_again
      end

      def upload
        process_upload_keys
        @type = params[:type]
        @keys.each { |key| initialize_attachment(key) }
        # rescue => ex
        #   Airbrake.notify ex
        #   return respond_with_error ex.message
      end

      def download
        file = @s3_object_ref
        object = @s3_bucket.object(file)

        safe_filename = file.split('/').last

        return unless object.exists?
        ref = object.get

        send_data ref.body.read, filename: safe_filename, type: ref.content_type,
                                 disposition: 'attachment', stream: 'true', buffer_size: '4096'
      end

      def info; end

      def delete
        if params[:apiVersion].present?
          file = current_user.file_attachments.find params[:id]
          file.destroy
        else
          delete_file_legacy
        end
      rescue ActiveRecord::RecordNotFound
        respond_with_error 'File not found'
      end

      private

      def delete_file_legacy
        filename = params[:file]
        type = params[:type]

        file_path = s3_file_path(filename)

        if s3_file_exists?(file_path)
          delete_on_s3(file_path)
          delete_in_database(type, filename)

          respond_with_success 'File deleted'
        else
          respond_with_error 'File does not exist'
        end
      end

      def validate_location
        return if !@zip_code || check_zip_code(@zip_code)

        raise 'Invalid City or Zip Code'
      end

      def save_new_email
        return unless @new_email
        if User.where(email: @new_email).any?
          raise 'Entered email address has already been registered. ' \
                                      'Please try with different email address.'
        end

        current_user.new_email = @new_email
        current_user.save!
        UserMailer.change_email(current_user.email, @new_email).deliver_now!
      end

      def save_user_details
        current_user.update! name: @name,
                             phone: @phone_number,
                             tagline: @about_me,
                             # job_position_id: @position,
                             available_for_work_on: @work_availability_date,
                             work_availability: work_availability_id_to_enum(@work_availability),
                             years_experience: years_experience_from_numeric(@experience),
                             notes: @comments,
                             location_range: miles_range_id_to_enum(@miles),
                             languages: @bilingual_languages,
                             new_practice_software: @new_practice_software,
                             compensation_type: compensation_id_to_enum(@compensation_id)

        current_user.job_positions = JobPosition.where(id: @position)
        current_user.save

        assign_user_job_types
      end

      def assign_user_job_types
        return unless params[:job_types]
        current_user.users_job_types = []
        if @job_types.present?
          @job_types.each { |job_type| current_user.users_job_types.create(job_type: job_type) }
        end
        current_user.save!
      end

      def save_practice_management
        return unless @practice_management_system.present? && @practice_management_system.any?

        ids = if @practice_management_system.is_a?(Array)
                @practice_management_system
              else
                @practice_management_system.split(',')
              end

        current_user.practice_management_systems = PracticeManagementSystem.where('id IN (?)', ids)
        current_user.save!
      end

      def save_additional_skills
        return unless @additional_skills.present? && @additional_skills.any?

        proficiencies = SoftwareProficiency.where('id IN (?)', @additional_skills)
        current_user.software_proficiencies = proficiencies
        current_user.save!
      end

      def save_address
        address = current_user.addresses.first || current_user.addresses.build
        address.address_line1 = @address_line1
        address.address_line2 = @address_line2
        address.city = @city
        address.state = @state
        address.zip_code = @zip_code
        address.save!
      end

      def save_certification
        certification = current_user.user_certifications.first || current_user.user_certifications.build
        certification.certified_by_board = @board_certified || false
        certification.license_number = @license_number
        certification.license_expiry = @license_expiry
        certification.license_verified_states = (@license_verified_states || []).join(',')
        certification.license_verified = @license_verified
        certification.save!
      end

      def save_salary_configuration
        current_user.salary_configuration ||= SalaryConfiguration.create

        salary_configuration = current_user.salary_configuration
        salary_configuration.salary_value = @salary || ''
        salary_configuration.range_low = @from_salary_range
        salary_configuration.range_high = @to_salary_range
        salary_configuration.save!
      end

      def save_shift_configuration
        return unless @shifts
        @shifts.each do |shift|
          shift_configuration = current_user.shift_configurations
                                            .find_or_initialize_by(shift_time: shift_id_to_time(shift['shiftID'].to_i))
          shift_configuration.shift_days = (shift['days'] || []).join(',')
          shift_configuration.save!
        end
      end

      def check_video_count
        return unless params[:type] == 'videoFiles'

        existing_videos = FileAttachment.where(user_id: current_user.id, attachment_type: 'video')
        respond_with_error('Video limit exceeded') if existing_videos.count >= 3
      end
    end
  end
end

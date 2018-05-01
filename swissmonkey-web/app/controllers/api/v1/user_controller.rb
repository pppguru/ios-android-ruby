require 'base64'

module Api
  module V1
    # User endpoints
    class UserController < ::Api::V1Controller
      skip_before_action :validate_user_authentication, only: %i[signup login forgot]
      before_action :parse_email
      before_action :set_user_from_email, only: %i[login forgot]
      before_action :validate_email_uniqueness, only: :signup
      before_action :validate_email, only: :login
      before_action :validate_user, only: :login
      before_action :validate_jobseeker, only: :login

      def signup
        user = User.create! new_user_params

        user.job_positions = JobPosition.where(id: params[:position])
        zip_code = params[:zip_code]&.strip
        user.addresses.create(zip_code: zip_code, state: '') if zip_code
        user.save!

        # TODO: reenable
        # UserMailer.welcome(email, token).deliver_now!
        respond_with_success 'User successfully created, please verify your email'
      end

      def validate
        render json: { success: true }
      end

      def login
        token = Digest::MD5.hexdigest(@email)
        # begin
        @user.token = token
        @user.save!

        if @user.blocked_access?
          render json: { authtoken: token, UserBlockedStatus: 'User Blocked' }
        else
          render json: { authtoken: token, status: 'Activated', privacy_policy_status: @user.accepted_terms }
        end
        # rescue => ex
        #   Airbrake.notify ex
        #   respond_with_try_again
        # end
      end

      def logout
        respond_with_success 'Logged out successfully'
      end

      def forgot
        return respond_with_error('Email is not registered') unless @user

        if @user.email_verified == 'No'
          resend_verification_email(@email)
          respond_with_error 'Verify your email to change password'
        else
          return respond_with_error 'Email is not registered' if @user.blank?
          @user.update! token: @token, token_expiration: 1.day.from_now

          UserMailer.password(@email, @token).deliver_now!
          respond_with_success 'Forgot password link has been sent to your registered Email Address.'
        end
      end

      def reset
        if User.authenticate! current_user.email, params[:oldpassword]
          current_user.password = params[:newpassword]
          current_user.save
          respond_with_success 'Updated password successfully'
        else
          respond_with_error 'Old password is incorrect'
        end
      end

      def deactivate
        current_user.active = false
        # begin
        current_user.save!
        # rescue => ex
        #   Airbrake.notify ex
        #   return respond_with_try_again
        # end
        respond_with_success 'Your account has been deactivated'
      end

      def activate
        current_user.active = true
        # begin
        current_user.save!
        # rescue => ex
        #   Airbrake.notify ex
        #   respond_with_try_again
        # end
        respond_with_success 'Your account has been activated'
      end

      def device_registration
        token = params[:token]
        device_type = params[:device_type]
        return unless token
        record = DeviceToken.find_by user_id: current_user.id, token: token
        unless record
          record = DeviceToken.new user_id: current_user.id, token: token
          record.device_type = device_type if device_type

          # begin
          record.save!
          # rescue => ex
          #   Airbrake.notify ex
          #   respond_with_error ex.message
          # end
        end

        respond_with_success 'Registered your device successfully'
      end

      def accept_privacy_policy
        @current_user.accepted_terms = true
        @current_user.save!
        render json: { success: true }
        # rescue
        #   respond_with_try_again
        # end
      end

      def privacy_policy_status
        render json: { success: true, privacy_policy_status: current_user.accepted_terms }
      end

      private

      def token_from_email(email)
        return if email.blank?
        Base64.encode64(email + Time.zone.now.to_formatted_s(:mysql_with_time))
      end

      def resend_verification_email(email)
        user = User.find_by user_name: email
        token = token_from_email(email)
        user.email_token = token
        user.token_expiry_time = 1.day.from_now
        user.save

        UserMailer.welcome(email, token).deliver_now!
      end

      def parse_email
        @email = params[:username]&.strip
        @token = token_from_email(@email)
      end

      def set_user_from_email
        @user = User.find_by email: @email
      end

      def validate_email_uniqueness
        return unless User.find_by('email = ? OR user_name = ? OR new_email = ?', @email, @email, @email)
        respond_with_error 'User already exists'
      end

      def new_user_params
        {
          user_name: @email, email: @email, name: params[:name],
          email_token: @token, role: 'JOBSEEKER', accepted_terms: true,
          email_expiration: 1.day.from_now,
          password: params[:password]
        }
      end

      def validate_email
        respond_with_error 'Email not registered' if @user.blank?
      end

      def validate_user
        respond_with_error 'Invalid credentials' unless User.authenticate! @email, params[:password]
      end

      def validate_jobseeker
        return if @user.job_seeker?
        respond_with_error 'Looks like you are trying to sign in as an employer.  Please use www.swissmonkey.io'
      end
    end
  end
end

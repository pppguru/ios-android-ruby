module Api
  module V1
    # Settings endpoints
    class SettingsController < ::Api::V1Controller
      def update
        current_user.location_range = params[:locationrange]
        current_user.alerts = params[:alertme] == 1
        current_user.save!

        respond_with_success 'Settings saved successfully'
      end

      def viewed
        viewed_ids = params[:viewed_ids]
        unless viewed_ids.any?
          render json: { success: false }, status: 400
          return
        end
        # begin
        UsersJobNotification.where('viewed_ids IN (?)', viewed_ids).update_all! viewed: 'Yes'
        render json: { success: true }
        # rescue
        #   render json: { success: false }, status: 400
        # end
      end

      def apinotifications
        @notifications = UsersJobNotification.where(user_id: current_user.id)
      end
    end
  end
end

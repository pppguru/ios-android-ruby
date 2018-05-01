module Api
  # base class for V1 endpoints
  class V1Controller < ::ApiController
    # alias_method :devise_user_signed_in?, :user_signed_in?
    alias devise_current_user current_user

    before_action :determine_current_user
    before_action :validate_user_authentication, except: [:datasets]

    def datasets
      @positions = JobPosition.where('name != ? AND sort_order > ?', 'Other', 0)
      @software_proficiency = SoftwareProficiency.order(:name).all

      assign_legacy_data

      practice_management_visibility = ['all']
      practice_management_visibility << current_user.id.to_s if current_user.present?
      @practice_management_software = PracticeManagementSystem.order(:software)
                                                              .visible_to(practice_management_visibility)
    end

    protected

    attr_reader :current_user

    def assign_legacy_data
      legacy = LEGACY_DATA['datasets']
      @experiences = legacy['experiences']
      @work_availability = legacy['work_availability']
      @compensations = legacy['compensation']
      @job_types = legacy['job_types']
      @shifts = legacy['shifts']
      @location_range = legacy['locations']
      @state_list = legacy['states']
    end

    def determine_current_user
      @current_user = if devise_current_user.present?
                        devise_current_user
                      elsif params[:authtoken].present?
                        User.find_by token: params[:authtoken]
                      end
    end

    def validate_user_authentication
      return if @current_user.present?
      render json: { error: 'Unauthorized user' }, status: 400
    end

    def user_signed_in?
      @current_user.present?
    end
  end
end

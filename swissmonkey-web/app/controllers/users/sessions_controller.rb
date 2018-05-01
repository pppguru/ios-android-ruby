module Users
  # Overridden from Devise
  class SessionsController < Devise::SessionsController
    # before_action :configure_sign_in_params, only: [:create]

    # GET /resource/sign_in
    # def new
    #   super
    # end

    # POST /resource/sign_in
    def create
      self.resource = warden.authenticate!(auth_options)
      set_flash_message!(:notice, :signed_in)
      sign_in(resource_name, resource)
      yield resource if block_given?

      process_after_sign_in(resource)
    end

    # DELETE /resource/sign_out
    # def destroy
    #   super
    # end

    # protected

    # If you have extra params to permit, append them to the sanitizer.
    # def configure_sign_in_params
    #   devise_parameter_sanitizer.permit(:sign_in, keys: [:attribute])
    # end

    private

    def process_after_sign_in(resource)
      if resource.is_a?(User) && resource.job_seeker?
        redirect_to "http://jobs.swissmonkey.co/signin/#{resource.auth_token}"
      else
        respond_with resource, location: after_sign_in_path_for(resource)
      end
    end
  end
end

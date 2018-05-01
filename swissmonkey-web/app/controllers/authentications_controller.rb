# Class used for single sign on via third-party auth
class AuthenticationsController < ApplicationController
  def facebook
    social_sign_in('Facebook')
  end

  def google
    social_sign_in('Google')
  end

  def linkedin
    social_sign_in('Linked In')
  end

  def failure
    flash[:error] = 'There was a problem signing you in. Please register or try signing in later.'
    redirect_to new_user_registration_url
  end

  private

  def social_sign_in(provider)
    @user = User.create_from_provider_data(request.env['omniauth.auth'])
    if @user.persisted?
      sign_in_and_redirect @user
      set_flash_message(:notice, provider) if is_navigational_format?
    else
      flash[:error] = "There was a problem signing you in through #{provider}. Please register or try signing in later."
      redirect_to new_user_registration_url
    end
  end

  def set_flash_message(type, provider)
    flash[type] = "You are now signed in through your #{provider} account"
  end
end

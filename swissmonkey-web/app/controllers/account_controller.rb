# Account-related functionality
class AccountController < AuthenticatedController
  # skip_before_action :authenticate_user!, only: :verify_email_change

  def verify_email_change
    token = params[:token]
    if current_user.new_email == token
      current_user.promote_new_email!

      msg = 'Your email address has been verified successfully. ' \
      'Please use the updated email to login into Swiss Monkey.'
      redirect_to root_path, notice: msg
    else
      head 401
    end
  end

  def set_current_company
    company = current_user.companies.find(params[:id])
    current_user.update last_company_context: company
    redirect_to(params[:destination].presence || job_postings_path)
  rescue ActiveRecord::RecordNotFound
    head 404
  end

  def logo_upload; end
end

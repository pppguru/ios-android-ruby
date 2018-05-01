# Job-related notifications
class JobMailer < ApplicationMailer
  # Subject can be set in your I18n file at config/locales/en.yml
  # with the following lookup:
  #
  #   en.job_mailer.user_applied_for_job.subject
  #
  def user_applied_for_job(company_email, data)
    @data = data
    @user_email = data[:user_email]
    @profile_pic = data[:profile_pic]
    @user_position_name = data[:user_position_name]
    @salary = data[:salary]

    parse_extra_data(data)

    mail to: company_email
  end

  private

  def parse_extra_data(data)
    @user_contact = data[:user_contact]
    @address = data[:address]
    @job_seeker_name = data[:job_seeker_name]
    @position_name = data[:position_name]
    @experience = data[:experience]
    @profile_match = data[:profile_match]
    @job_apply_id = data[:job_apply_id]
  end
end

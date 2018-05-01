# Helper methods around applying for jobs
module JobApplicationHelper
  # Used by API V1
  def initialize_application
    @application = JobApplication.find_or_initialize_by(job_posting_id: @job.id,
                                                        user_id: current_user.id, application_status: 'SAVED')

    if @application.id.present?
      respond_with_success('Already applied for this job')
    else
      @application.application_status = 'PENDING'
      @application.save!
    end
  end
end

# Helper methods for listing jobs
module JobListHelper
  def initialize_job_list_query
    @jobs_query = JobPosting
                  .order(created_at: :desc)
                  .where job_position_id: current_user.job_positions.map(&:id),
                         publication_status: 'PUBLISHED'
  end

  def filter_out_excluded_companies
    excluded_company_ids = Company.excluded_from_search_results_for_user(current_user).map(&:id)
    return if excluded_company_ids.empty?
    @jobs_query = @jobs_query.where('company_id NOT IN (?)', excluded_company_ids)
  end
end

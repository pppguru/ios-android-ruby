# Job Applicants
class ApplicantsController < ApplicationController
  include ProximityHelper

  before_action :parse_params, only: [:index]
  before_action :set_companies_and_positions, only: [:index]
  before_action :set_job_posting_ids, only: [:index]
  before_action :set_users_info, only: [:index]
  before_action :query_jobs, only: [:index]
  before_action :set_applicant_counts, only: [:index]
  before_action :validate_company_access, only: [:index]
  before_action :build_applications_query, only: [:index]

  def index
    @job_postings.each { |job| rank_applicants(job) }
    render
  end

  private

  def applicant_hash(application)
    hash = application.applicant_hash
    hash[:distance] = applicant_distance(hash, self)

    hash
  end

  def rank_applicants(job)
    applicants = query_applicants(job)
    job_applicants_ranking = {}
    return unless applicants.any?
    applicants.each do |application|
      next if @accepted_applicants[application.user_id]

      @accepted_applicants[application.user_id] = applicant_hash(application)
      job_applicants_ranking[application.user_id] = rank_application(application)
    end
    job_applicants_ranking.sort_by { |_key, value| -value }
    @accepted_ranking[job.rank_key] = job_applicants_ranking
  end

  def rank_application(application)
    SwissMonkey::UserJobRanking.new(application.job_posting.id, application.user_id).rank
  end

  def set_users_info
    users = JobApplication.where(job_posting_id: @job_posting_ids, application_status: @status).map(&:user).uniq

    @users_info = []
    users.each do |user|
      @users_info << "#{user.name} - #{user.email}"
    end
  end

  def applicant_distance(_hash, application)
    job_coords = SwissMonkey::Geocoder.get_coordinates(application.job_posting.company_location.zip_code)
    user_coords = SwissMonkey::Geocoder.get_coordinates(application.user.addresses.first&.zip_code)
    return nil unless job_coords[:latitude] && user_coords[:latitude]
    distance_from_hash(job_coords, user_coords)
  end

  def query_applicants(job)
    if @search
      job.job_applications.joins(:user)
         .where('job_applications.application_status = ?
                              AND (user.name LIKE ? OR user.email LIKE ?)',
                @status, @search, @search)
    else
      job.job_applications.where(application_status: @status)
    end
  end

  def query_jobs
    postings = if @search
                 like_expression = '%' + @search + '%'
                 JobPosting.joins(job_applications: :users)
                           .where('job_postings.id IN (?) AND
                              job_applications.application_status = ? AND
                              users.name LIKE ? OR users.email LIKE ?', @job_posting_ids, @status, like_expression)
               else
                 JobPosting.joins(:job_applications)
                           .where('job_postings.id IN (?) AND job_applications.application_status = ?',
                                  @job_posting_ids, @status)
               end
    @job_postings = postings.page(params[:page])
  end

  def set_applicant_counts
    base_query = JobApplication.where(job_posting_id: @job_posting_ids)
    # Getting applicants count by status
    @pending_applicants_count = base_query.where(application_status: 'PENDING').count
    @rejected_applicants_count = base_query.where(application_status: 'REJECTED').count
    @accepted_applicants_count = base_query.where(application_status: 'ACCEPTED').count
  end

  def set_job_posting_ids
    job_criteria = @job_posting_id == 'allpostings' ? { company_id: @company_applicants } : { id: @job_posting_id }
    @job_posting_ids = JobPosting.where(job_criteria).map(&:id)
  end

  def set_companies_and_positions
    @companies = current_user.companies
    @company_ids = @companies.map(&:id)

    if @company_id == 'practices'
      @company_applicants = @company_ids
      @positions_list = []
    else
      @company_applicants = [@company_id]
      @positions_list = @company.job_postings
    end
  end

  def parse_params
    @application_status = params[:application_status]
    @company_id = (params[:company_id] || '').to_i
    @job_posting_id = params[:job_posting_id]
    @search = params[:search]
    @status = @application_status == 'All' || @application_status.blank? ? 'SAVED' : @application_status&.upcase
    @accepted_applicants = {}
    @accepted_ranking = {}
  end

  def validate_company_access
    @company_ids = current_user.companies.map(&:id)
    unless @application_status != 'All' && (@company_id != 'practices') && !@company_ids.include?(@company_id.to_i)
      return
    end
    redirect_to root_path
  end

  def set_company
    return if @company_id == 'practices'
    @company = current_user.companies.find_by @company_id
  end

  def build_applications_query
    @base_query = JobApplication

    @base_query = if params[:company_id]
                    @base_query.by_company(params[:company_id])
                  else
                    @base_query.all
                  end

    filter_query_by_job
    filter_query_by_status
  end

  def filter_query_by_job
    return unless params[:job_posting_id]
    @base_query = @base_query.by_job_posting(params[:job_posting_id])
  end

  def filter_query_by_status
    return unless params[:application_status]

    @base_query = @base_query.by_application_status(params[:application_status])
  end
end

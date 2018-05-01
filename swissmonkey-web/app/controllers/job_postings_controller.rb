# Employer job posting management
class JobPostingsController < AuthenticatedController
  include EnumerationsHelper
  include SortHelper
  include ProximityHelper

  # NOTE: there is some code for the old pushnotificationspool (ported from Laravel) here:
  # https://gist.github.com/nlively/450b617dc76a5a3b45b29194efe11e9c

  before_action :set_closed_job_reasons
  before_action :set_job_posting, only: %i[show edit update destroy publish_job]
  before_action :setup_form, only: %i[new edit update create]
  before_action :company_from_location, only: %i[create update]
  before_action :process_job_closing, only: :update

  # GET /job_postings
  # GET /job_postings.json
  def index
    @job_postings = JobPosting
                    .by_companies(@company_context&.id)
                    .order("#{sort_column} #{sort_direction}")
                    .page(params[:page])
  end

  # GET /job_postings/1
  # GET /job_postings/1.json
  def show; end

  # GET /job_postings/new
  def new
    @job_posting = JobPosting.new

    @check = true
  end

  # GET /job_postings/1/edit
  def edit
    @check = false
  end

  # POST /job_postings
  # POST /job_postings.json
  def create
    @job_posting = JobPosting.new(job_posting_params)
    @job_posting.company = @company
    @job_posting.publication_status = 'PUBLISHED'

    respond_to do |format|
      if @job_posting.save
        format.html { redirect_to @job_posting, notice: 'Job posting was successfully created.' }
        format.json { render :show, status: :created, location: @job_posting }
      else
        format.html { render :new }
        format.json { render json: @job_posting.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /job_postings/1
  # PATCH/PUT /job_postings/1.json
  def update
    respond_to do |format|
      @job_posting.assign_attributes(job_posting_params)
      @job_posting.company = @company
      if @job_posting.save!
        format.html { redirect_to @job_posting, notice: 'Job posting was successfully updated.' }
        format.json { render :show, status: :ok, location: @job_posting }
      else
        format.html { render :edit }
        format.json { render json: @job_posting.errors, status: :unprocessable_entity }
      end
    end
  end

  def process_job_closing
    return unless params[:action] == 'close'

    @job_posting.publication_status = 'CLOSED'
    @job_posting.closed_job_reason = determine_closed_job_reason
    @job_posting.save!
    respond_with_success('Job has been updated')
    # rescue => ex
    #   Airbrake.notify ex
    #   return respond_with_try_again
  end

  def determine_closed_job_reason
    other_reason = params[:other_reason]
    closed_job_reason = ClosedJobReason.find_by id: params[:closing_reason_id]
    if closed_job_reason&.reason == 'Other' && other_reason.present?
      ClosedJobReason.create! reason: other_reason, private: true
    else
      closed_job_reason
    end
  end

  # DELETE /job_postings/1
  # DELETE /job_postings/1.json
  def destroy
    @job_posting.destroy
    respond_to do |format|
      format.html { redirect_to job_postings_url, notice: 'Job posting was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  def publish_job
    @job_posting.update! publication_status: 'PUBLISHED', closed_job_reason_id: nil
    redirect_to job_posting_path(@job_posting)
  end

  private

  def setup_form
    company_ids = current_user.companies.map(&:id)

    @extend_free = false # TODO: possibly expand this later
    @practice_locations = CompanyLocation.where(company_id: company_ids)
    @job_positions = JobPosition.order(:name).all
    @practice_management_systems = PracticeManagementSystem.order(:software).all
    @software_proficiencies_top_level = SoftwareProficiency.without_children
    @software_proficiencies_with_children = SoftwareProficiency.with_children
  end

  # Use callbacks to share common setup or constraints between actions.
  def set_job_posting
    id = if params[:job_posting_id]
           params[:job_posting_id]
         else
           params[:id]
         end

    @job_posting = JobPosting.by_companies(current_user.companies).find_by(id: id)

    redirect_to(root_path) unless @job_posting
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def job_posting_params
    params.require(:job_posting).permit(
      :job_position_id, :job_description,
      :closed_job_reason_id, :skype_interview,
      :company_id, :logo,
      :company_location_id, :compensation_type,
      :publication_status, :years_experience,
      :job_type, :payment_type, :fill_by,
      :languages, :require_photo, :require_video,
      :compensation_range_low, :compensation_range_high,
      :expiration, :custom_practice_software,
      :require_resume, :require_recommendation_letter
    )
  end

  def set_closed_job_reasons
    @closed_job_reasons = ClosedJobReason.universal.order(:reason)
  end

  def company_from_location
    @company = CompanyLocation.find(params[:job_posting][:company_location_id]).company
  end
end

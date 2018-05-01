# Manages companies / practice profiles
class CompaniesController < AuthenticatedController
  include CompanyHelper
  before_action :set_company, only: %i[show edit update destroy]
  before_action :parse_update_params, only: %i[update]
  before_action :assign_practice_management_systems, only: %i[update]
  before_action :assign_company_benefits, only: %i[update]

  # GET /companies
  # GET /companies.json
  def index
    @companies = Company.all
  end

  # GET /companies/1
  # GET /companies/1.json
  def show; end

  # GET /companies/new
  def new
    @company = Company.new
  end

  # GET /companies/1/edit
  def edit; end

  # POST /companies
  # POST /companies.json
  def create
    @company = Company.new(company_params)

    respond_to do |format|
      if @company.save
        format.html { redirect_to @company, notice: 'Company was successfully created.' }
        format.json { render :show, status: :created, location: @company }
      else
        format.html { render :new }
        format.json { render json: @company.errors, status: :unprocessable_entity }
      end
    end
  end

  # PATCH/PUT /companies/1
  # PATCH/PUT /companies/1.json
  def update
    update_company!

    # current_user.update! name: @name if @first_company == 'yes'

    if @company_id == 'new'
      @company_id = @company.company_id
      current_user.companies << @company
    end

    update_company_location!
    process_email_change
  end

  # DELETE /companies/1
  # DELETE /companies/1.json
  def destroy
    @company.destroy
    respond_to do |format|
      format.html { redirect_to companies_url, notice: 'Company was successfully destroyed.' }
      format.json { head :no_content }
    end
  end

  private

  def set_company
    @company_id = params[:company_id] || params[:id]
    all_companies = current_user.companies.map(&:id)
    @first_company = @company_id == all_companies.first ? 'yes' : 'no'
    @company = Company.find_by(id: @company_id) || Company.new
  end

  # Never trust parameters from the scary internet, only allow the white list through.
  def company_params
    params.fetch(:company, {})
  end
end

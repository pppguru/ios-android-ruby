# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended that you check this file into your version control system.

class CreateDatabase < ActiveRecord::Migration

  create_table "addresses", force: :cascade do |t|
    t.integer "user_id", limit: 4, null: false
    t.string "address_line1", limit: 100
    t.string "address_line2", limit: 200
    t.string "city", limit: 200
    t.string "state", limit: 200, null: false
    t.string "zip_code", limit: 100, null: false
    t.string "country", limit: 100

    t.timestamps null: true
  end

  # add_index "addresses", ["user_id"], name: "address_user_id_foreignkey", using: :btree

  create_table "android_users", force: :cascade do |t|
    t.string "email", limit: 100
    t.timestamps null: true
  end

  create_table "closed_job_reasons", force: :cascade do |t|
    t.string "reason", limit: 250, null: false
    t.string "description", limit: 250, null: false
    t.string "status", limit: 250, null: false
    t.timestamps null: true
  end

  create_table "companies", force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "anonymous", limit: 1, default: 0, null: false
    t.string "website", limit: 250, null: false
    t.string "length_of_appointment", limit: 250, null: false
    t.string "total_doctors", limit: 250, null: false
    t.string "number_of_operatories", limit: 250, null: false
    t.text "about", null: false
    t.string "digital_xray", limit: 100, null: false
    t.string "other_benefits", limit: 250, null: false
    t.string "company_established", limit: 250
    t.string "video_link", limit: 100
    t.integer "employer_user_id", limit: 4
    t.string "contact_name", limit: 200
    t.integer "contact_anonymous"
    t.string "contact_email", limit: 255
    t.string "contact_number", limit: 255
    t.string "contact_private_number", limit: 255
    t.timestamps null: true
  end

  add_index "companies", ["employer_user_id"], name: "Company_User_userId_fk", using: :btree

  create_table "companies_employee_benefits", id: false, force: :cascade do |t|
    t.integer "company_id", limit: 4, null: false
    t.integer "employee_benefit_id", limit: 4, null: false
  end

  add_index "companies_employee_benefits", ["company_id", "employee_benefit_id"], name: "ix_CompanyEmployeeBenefit", unique: true, using: :btree
  add_index "companies_employee_benefits", ["employee_benefit_id"], name: "CompanyEmployeeBenefit_EmployeeBenefit_companyId_fk", using: :btree

  create_table "companies_practice_management_systems", id: false, force: :cascade do |t|
    t.integer "company_id", limit: 4, null: false
    t.integer "practice_management_system_id", limit: 4, null: false
  end

  add_index "companies_practice_management_systems", ["practice_management_system_id"], name: "companiesPracticeManagementSystemId", using: :btree

  create_table "company_locations", force: :cascade do |t|
    t.string "address_line1", limit: 250, null: false
    t.string "address_line2", limit: 250, null: false
    t.string "city", limit: 200, null: false
    t.string "state", limit: 250, null: false
    t.string "zip_code", limit: 100, null: false
    t.integer "company_id", limit: 4, null: false

    t.timestamps null: true
  end

  add_index "company_locations", ["company_id"], name: "company_location_company_id_foreign", using: :btree

  create_table "device_tokens", force: :cascade do |t|
    t.string "token", limit: 250, null: false
    t.integer "user_id", limit: 4, null: false
    t.string "device_type", limit: 255, default: "iOS", null: false
    t.timestamps null: true
  end

  add_index "device_tokens", ["user_id"], name: "DeviceToken_User_userId_fk", using: :btree

  create_table "employee_benefits", force: :cascade do |t|
    t.string "name", limit: 250, null: false
    t.string "predefined_benefit_list", limit: 100, null: false
    t.timestamps null: true
  end

  create_table "file_attachments", force: :cascade do |t|
    t.string "attachment_type", limit: 100, null: false
    t.string "name", limit: 250, null: false
    t.integer "sort_order", limit: 4, null: false
    t.integer "user_id", limit: 4, null: false
    t.string "status", limit: 1, null: false
    t.integer "company_id", limit: 4, null: false

    t.timestamps null: true
  end

  add_index "file_attachments", ["company_id"], name: "FileAttachment_Company_companyId_fk", using: :btree
  add_index "file_attachments", ["user_id"], name: "attachment_user_id_foreign", using: :btree

  create_table "job_applications", force: :cascade do |t|
    t.integer "user_id", limit: 4, null: false
    t.integer "job_posting_id", limit: 4, null: false
    t.string "application_status", limit: 30
    t.integer "viewed_by_employer", default: 0, null: false

    t.timestamps null: true
  end

  add_index "job_applications", ["job_posting_id"], name: "job_status_table_job_id_foreign", using: :btree
  add_index "job_applications", ["user_id"], name: "job_status_table_user_id_foreign", using: :btree

  create_table "job_positions", force: :cascade do |t|
    t.string "name", limit: 255
    t.integer "sort_order", limit: 4

    t.timestamps null: true
  end

  create_table "job_postings", force: :cascade do |t|
    t.integer "job_position_id", limit: 4
    t.text "job_description"
    t.integer "closed_job_reason_id", limit: 4
    t.string "skype_interview", limit: 100, default: "No", null: false
    t.string "resume", limit: 255
    t.integer "company_id", limit: 4
    t.string "logo", limit: 250, null: false
    t.string "letter_of_recommendation", limit: 255
    t.string "compensation_range_low", limit: 250
    t.string "compensation_range_high", limit: 250
    t.integer "company_location_id", limit: 4
    t.string "compensation_type", limit: 20
    t.string "publication_status", limit: 20
    t.string "years_experience", limit: 20
    t.string "job_type", limit: 30
    t.string "payment_type", limit: 20
    t.date "fill_by"
    t.integer "photo_required", default: 0, null: false
    t.integer "video_required", default: 0, null: false
    t.string "languages"

    t.timestamps null: true
  end

  add_index "job_postings", ["closed_job_reason_id"], name: "JobPosting_ClosedJobReason_reason_id_fk", using: :btree
  add_index "job_postings", ["company_id"], name: "job_table_company_id_foreign", using: :btree
  add_index "job_postings", ["job_position_id"], name: "job_table_position_foreign", using: :btree

  create_table "job_postings_practice_management_systems", id: false, force: :cascade do |t|
    t.integer "job_posting_id", limit: 4, null: false
    t.integer "practice_management_system_id", limit: 4, null: false
  end

  add_index "job_postings_practice_management_systems", ["practice_management_system_id"], name: "jobPostingsPracticeManagementSystemId", using: :btree

  create_table "job_postings_shift_configurations", force: :cascade do |t|
    t.integer "job_posting_id", limit: 4, null: false
    t.integer "shift_configuration_id", limit: 4

    t.timestamps null: true
  end

  add_index "job_postings_shift_configurations", ["job_posting_id"], name: "job_shifts_table_job_id_foreign", using: :btree
  add_index "job_postings_shift_configurations", ["shift_configuration_id"], name: "JPSC_ShiftConfiguration_shiftConfigurationId_fk", using: :btree

  create_table "job_postings_software_proficiencies", id: false, force: :cascade do |t|
    t.integer "job_posting_id", limit: 4, null: false
    t.integer "software_proficiency_id", limit: 4, null: false
  end

  add_index "job_postings_software_proficiencies", ["job_posting_id", "software_proficiency_id"], name: "ix_JobSoftwareProficiency", unique: true, using: :btree
  add_index "job_postings_software_proficiencies", ["software_proficiency_id"], name: "JobSoftwareProficiency_SoftwareProficiency_userId_fk", using: :btree

  create_table "job_postings_views", force: :cascade do |t|
    t.integer "job_posting_id", limit: 4, null: false
    t.integer "user_id", limit: 4, null: false
    t.datetime "view_time", null: false

    t.timestamps null: true
  end

  add_index "job_postings_views", ["job_posting_id"], name: "job_views_table_job_id_foreign", using: :btree
  add_index "job_postings_views", ["user_id"], name: "job_views_table_user_id_foreign", using: :btree

  create_table "media", force: :cascade do |t|
    t.string "file", limit: 250, null: false
    t.integer "sort_order", limit: 4, null: false
    t.string "file_type", limit: 100, null: false
    t.integer "user_id", limit: 4, null: false
    t.string "thumbnail", limit: 2000

    t.timestamps null: true
  end

  add_index "media", ["user_id"], name: "media_table_jobseeker_id_foreign", using: :btree

  create_table "practice_management_systems", force: :cascade do |t|
    t.string "software", limit: 250, null: false
    t.string "status", limit: 1, null: false
    t.string "visible_to", limit: 200, default: "all", null: false
    t.string "software_value", limit: 100, null: false

    t.timestamps null: true
  end

  create_table "salary_configurations", force: :cascade do |t|
    t.string "salary_name", limit: 100, null: false
    t.string "salary_value", limit: 100, null: false
    t.string "status", limit: 1, null: false
    t.string "salary_range_low", limit: 100, null: false
    t.string "salary_range_high", limit: 100, null: false

    t.timestamps null: true
  end

  create_table "shift_configurations", force: :cascade do |t|
    t.string "shift_days", limit: 255, null: false
    t.string "shift_time", limit: 255, null: false
  end

  create_table "software_proficiencies", force: :cascade do |t|
    t.string "name", limit: 250, null: false
    t.string "value", limit: 250, null: false
    t.string "status", limit: 1, null: false
    t.integer "parent_id", limit: 4

    t.timestamps null: true
  end

  add_index "software_proficiencies", ["parent_id"], name: "softwareProficiencyId_fk", using: :btree

  create_table "user_certifications", force: :cascade do |t|
    t.integer "user_id", limit: 4, null: false
    t.integer "board_certified"
    t.string "license_number", limit: 200
    t.date "license_expiry"
    t.string "license_verified_states", limit: 250
    t.string "verified", limit: 100

    t.timestamps null: true
  end

  add_index "user_certifications", ["user_id"], name: "fk_user_id", using: :btree

  create_table "users", force: :cascade do |t|
    t.string "first_name", limit: 100, null: false
    t.string "contact_name", limit: 250, null: true
    t.string "email", limit: 100, null: false
    t.string "phone", limit: 255, null: true
    t.integer "job_position_id", limit: 4
    t.string "photo", limit: 100, null: true
    t.string "role", limit: 20
    t.text "tagline"
    t.integer "salary_configuration_id", limit: 4
    t.text "notes"
    t.string "stripe_customer_id", limit: 50
    t.integer "alerts_enabled"
    t.string "location_range", limit: 20
    t.integer "blocked", default: 0, null: false
    t.integer "virtual_interview", limit: 4
    t.string "new_practice", limit: 250
    t.string "new_practice_software", limit: 250
    t.string "compensation_type", limit: 20
    t.string "years_experience", limit: 20
    t.string "work_availability", limit: 30
    t.date "available_for_work_on"
    t.string "user_name", limit: 100
    t.string "token", limit: 200
    t.datetime "token_expiration"
    t.string "email_token", limit: 250
    t.string "email_verified", limit: 100
    t.datetime "email_expiration"
    t.string "user_type", limit: 100
    t.string "new_email", limit: 100
    t.string "previous_emails", limit: 300
    t.integer "agree_to_terms"
    t.integer "is_active"
    t.string "languages"

    t.timestamps null: true
  end

  add_index "users", ["job_position_id"], name: "User_JobPosition_jobPositionId_fk", using: :btree
  add_index "users", ["salary_configuration_id"], name: "User_SalaryConfiguration_salary_id_fk", using: :btree

  create_table "users_companies", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4, null: false
    t.integer "company_id", limit: 4, null: false
  end

  add_index "users_companies", ["company_id"], name: "company_id", using: :btree

  create_table "users_job_notifications", force: :cascade do |t|
    t.integer "job_posting_id", limit: 4, null: false
    t.integer "user_id", limit: 4, null: false
    t.string "notification_description", limit: 250, null: false
    t.string "viewed", limit: 100, null: false

    t.timestamps null: true
  end

  add_index "users_job_notifications", ["job_posting_id"], name: "notifications_table_job_id_foreign", using: :btree
  add_index "users_job_notifications", ["user_id"], name: "notifications_table_user_id_foreign", using: :btree

  create_table "users_practice_management_systems", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4, null: false
    t.integer "practice_management_system_id", limit: 4, null: false
  end

  add_index "users_practice_management_systems", ["practice_management_system_id"], name: "usersPracticeManagementSystemId", using: :btree

  create_table "users_shift_configurations", primary_key: "shift_configuration_id", force: :cascade do |t|
    t.integer "user_id", limit: 4, null: false
    t.timestamps null: true
  end

  add_index "users_shift_configurations", ["user_id"], name: "UserShiftPreference_User_userId_fk", using: :btree

  create_table "users_software_proficiencies", id: false, force: :cascade do |t|
    t.integer "user_id", limit: 4, null: false
    t.integer "software_proficiency_id", limit: 4, null: false
  end

  add_index "users_software_proficiencies", ["software_proficiency_id"], name: "UserSoftwareProficiency_SoftwareProficiency_userId_fk", using: :btree
  add_index "users_software_proficiencies", ["user_id", "software_proficiency_id"], name: "ix_UserSoftwareProficiency", unique: true, using: :btree

  create_table "zip_codes", force: :cascade do |t|
    t.float "longitude", limit: 24
    t.float "latitude", limit: 24, null: false
    t.string "zip_code", limit: 10, null: false
    t.string "city", limit: 100, null: false
    t.timestamps null: true
  end

  # add_foreign_key "addresses", "users", name: "Address_User_userId_fk"
  add_foreign_key "companies", "users", column: "employer_user_id", name: "Company_User_userId_fk"
  add_foreign_key "companies_employee_benefits", "companies", name: "CompanyEmployeeBenefit_Company_companyId_fk"
  add_foreign_key "companies_employee_benefits", "employee_benefits", name: "CompanyEmployeeBenefit_EmployeeBenefit_companyId_fk"
  add_foreign_key "companies_practice_management_systems", "companies", name: "companies_practice_management_systems_ibfk_1", on_delete: :cascade
  add_foreign_key "companies_practice_management_systems", "practice_management_systems", name: "companies_practice_management_systems_ibfk_2", on_delete: :cascade
  add_foreign_key "company_locations", "companies", name: "CompanyLocation_Company_companyId_fk"
  add_foreign_key "device_tokens", "users", name: "DeviceToken_User_userId_fk"
  add_foreign_key "file_attachments", "companies", name: "FileAttachment_Company_companyId_fk"
  add_foreign_key "file_attachments", "users", name: "FileAttachment_User_userId_fk"
  add_foreign_key "job_applications", "job_postings", column: "job_posting_id", name: "UserJobStatus_JobPosting_jobPostingId_fk"
  add_foreign_key "job_applications", "users", column: "user_id", name: "UserJobStatus_User_userId_fk"
  add_foreign_key "job_postings", "closed_job_reasons", name: "JobPosting_ClosedJobReason_reason_id_fk"
  add_foreign_key "job_postings", "companies", name: "JobPosting_Company_companyId_fk"
  add_foreign_key "job_postings", "job_positions", name: "JobPosting_JobPosition_jobPositionId_fk"
  add_foreign_key "job_postings_practice_management_systems", "job_postings", name: "job_postings_practice_management_systems_ibfk_1", on_delete: :cascade
  add_foreign_key "job_postings_practice_management_systems", "practice_management_systems", name: "job_postings_practice_management_systems_ibfk_2", on_delete: :cascade
  add_foreign_key "job_postings_shift_configurations", "job_postings", name: "JobShift_JobPosting_jobPostingId_fk"
  add_foreign_key "job_postings_shift_configurations", "shift_configurations", name: "JPSC_ShiftConfiguration_shiftConfigurationId_fk"
  add_foreign_key "job_postings_software_proficiencies", "job_postings", name: "JobSoftwareProficiency_JobPosting_userId_fk", on_delete: :cascade
  add_foreign_key "job_postings_software_proficiencies", "software_proficiencies", name: "JobSoftwareProficiency_SoftwareProficiency_userId_fk", on_delete: :cascade
  add_foreign_key "job_postings_views", "job_postings", name: "JobPostingView_JobPosting_jobPostingId_fk"
  add_foreign_key "job_postings_views", "users", name: "JobPostingView_User_userId_fk"
  add_foreign_key "media", "users", name: "Media_User_userId_fk"
  add_foreign_key "software_proficiencies", "software_proficiencies", column: "parent_id", name: "SoftwareProficiency_SoftwareProficiency_softwareProficiencyId_fk"
  add_foreign_key "user_certifications", "users", name: "UserCertification_User_userId_fk"
  add_foreign_key "users", "job_positions", name: "User_JobPosition_jobPositionId_fk"
  add_foreign_key "users", "salary_configurations", name: "User_SalaryConfiguration_salary_id_fk"
  add_foreign_key "users_companies", "companies", name: "users_companies_ibfk_2", on_delete: :cascade
  add_foreign_key "users_companies", "users", name: "users_companies_ibfk_1", on_delete: :cascade
  add_foreign_key "users_job_notifications", "job_postings", name: "UserJobNotification_JobPosting_jobPostingId_fk", on_delete: :cascade
  add_foreign_key "users_job_notifications", "users", name: "UserJobNotification_User_userId_fk", on_delete: :cascade
  add_foreign_key "users_practice_management_systems", "practice_management_systems", name: "users_practice_management_systems_ibfk_2", on_delete: :cascade
  add_foreign_key "users_practice_management_systems", "users", name: "users_practice_management_systems_ibfk_1", on_delete: :cascade
  add_foreign_key "users_shift_configurations", "shift_configurations", name: "USC_ShiftConfiguration_shiftConfigurationId_fk"
  add_foreign_key "users_shift_configurations", "users", name: "UserShiftPreference_User_userId_fk"
  add_foreign_key "users_software_proficiencies", "software_proficiencies", name: "UserSoftwareProficiency_SoftwareProficiency_userId_fk", on_delete: :cascade
  add_foreign_key "users_software_proficiencies", "users", name: "UserSoftwareProficiency_User_userId_fk", on_delete: :cascade
end

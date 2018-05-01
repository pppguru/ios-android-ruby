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

ActiveRecord::Schema.define(version: 20180319032446) do

  # These are extensions that must be enabled in order to support this database
  enable_extension "plpgsql"

  create_table "addresses", force: :cascade do |t|
    t.integer  "user_id",                   null: false
    t.string   "address_line1", limit: 100
    t.string   "address_line2", limit: 200
    t.string   "city",          limit: 200
    t.string   "state",         limit: 200
    t.string   "zip_code",      limit: 100, null: false
    t.string   "country",       limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "admins", force: :cascade do |t|
    t.string   "email",                  default: "", null: false
    t.string   "encrypted_password",     default: "", null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",          default: 0,  null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.datetime "created_at",                          null: false
    t.datetime "updated_at",                          null: false
    t.index ["email"], name: "index_admins_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_admins_on_reset_password_token", unique: true, using: :btree
  end

  create_table "affiliations", force: :cascade do |t|
    t.string   "name"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "android_users", force: :cascade do |t|
    t.string   "email",      limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "closed_job_reasons", force: :cascade do |t|
    t.string   "reason",      limit: 250,                 null: false
    t.string   "description", limit: 250,                 null: false
    t.string   "status",      limit: 250,                 null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "private",                 default: false, null: false
  end

  create_table "companies", force: :cascade do |t|
    t.string   "name",                         limit: 255,                 null: false
    t.string   "website",                      limit: 250
    t.string   "length_of_appointment",        limit: 250
    t.string   "total_doctors",                limit: 250
    t.string   "number_of_operatories",        limit: 250
    t.text     "about"
    t.string   "digital_xray",                 limit: 100
    t.string   "other_benefits",               limit: 250
    t.string   "company_established",          limit: 250
    t.string   "video_link",                   limit: 100
    t.integer  "employer_user_id"
    t.string   "contact_name",                 limit: 200
    t.string   "contact_email",                limit: 255
    t.string   "contact_number",               limit: 255
    t.string   "contact_private_number",       limit: 255
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "email"
    t.string   "stripe_customer_id"
    t.string   "stripe_subscription_id"
    t.string   "stripe_plan"
    t.boolean  "active",                                   default: true,  null: false
    t.boolean  "trial",                                    default: true,  null: false
    t.datetime "trial_expiration"
    t.datetime "initial_conversion_date"
    t.boolean  "pending_deactivation",                     default: false, null: false
    t.datetime "trial_expired_reminder_sent"
    t.datetime "trial_expiring_reminder_sent"
    t.integer  "affiliation_id"
    t.boolean  "anonymous_company",                        default: false, null: false
    t.boolean  "anonymous_contact",                        default: false, null: false
    t.datetime "subscription_expiration"
    t.index ["affiliation_id"], name: "index_companies_on_affiliation_id", using: :btree
    t.index ["employer_user_id"], name: "Company_User_userId_fk", using: :btree
  end

  create_table "companies_employee_benefits", id: false, force: :cascade do |t|
    t.integer "company_id",          null: false
    t.integer "employee_benefit_id", null: false
    t.index ["company_id", "employee_benefit_id"], name: "ix_CompanyEmployeeBenefit", unique: true, using: :btree
    t.index ["employee_benefit_id"], name: "CompanyEmployeeBenefit_EmployeeBenefit_companyId_fk", using: :btree
  end

  create_table "companies_practice_management_systems", id: false, force: :cascade do |t|
    t.integer "company_id",                    null: false
    t.integer "practice_management_system_id", null: false
    t.index ["practice_management_system_id"], name: "companiesPracticeManagementSystemId", using: :btree
  end

  create_table "company_locations", force: :cascade do |t|
    t.string   "address_line1", limit: 250, null: false
    t.string   "address_line2", limit: 250
    t.string   "city",          limit: 200, null: false
    t.string   "state",         limit: 250, null: false
    t.string   "zip_code",      limit: 100, null: false
    t.integer  "company_id",                null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "country"
    t.index ["company_id"], name: "company_location_company_id_foreign", using: :btree
  end

  create_table "device_tokens", force: :cascade do |t|
    t.string   "token",       limit: 250,                 null: false
    t.integer  "user_id",                                 null: false
    t.string   "device_type", limit: 255, default: "iOS", null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "DeviceToken_User_userId_fk", using: :btree
  end

  create_table "employee_benefits", force: :cascade do |t|
    t.string   "name",                    limit: 250, null: false
    t.string   "predefined_benefit_list", limit: 100, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "file_attachments", force: :cascade do |t|
    t.string   "attachment_type",   limit: 100,                 null: false
    t.string   "name",              limit: 250
    t.integer  "sort_order",                    default: 0,     null: false
    t.integer  "user_id",                                       null: false
    t.string   "status",            limit: 1
    t.integer  "company_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "file_file_name"
    t.string   "file_content_type"
    t.integer  "file_file_size"
    t.datetime "file_updated_at"
    t.boolean  "uses_paperclip",                default: false, null: false
    t.string   "thumbnail"
    t.index ["company_id"], name: "FileAttachment_Company_companyId_fk", using: :btree
    t.index ["user_id"], name: "attachment_user_id_foreign", using: :btree
  end

  create_table "job_applications", force: :cascade do |t|
    t.integer  "user_id",                                       null: false
    t.integer  "job_posting_id",                                null: false
    t.string   "application_status", limit: 30
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "employer_viewed",               default: false, null: false
    t.index ["job_posting_id"], name: "job_status_table_job_id_foreign", using: :btree
    t.index ["user_id"], name: "job_status_table_user_id_foreign", using: :btree
  end

  create_table "job_positions", force: :cascade do |t|
    t.string   "name",       limit: 255
    t.integer  "sort_order"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "job_postings", force: :cascade do |t|
    t.integer  "job_position_id"
    t.text     "job_description"
    t.integer  "closed_job_reason_id"
    t.string   "skype_interview",               limit: 100,                          default: "No",  null: false
    t.integer  "company_id"
    t.string   "logo",                          limit: 250
    t.integer  "company_location_id"
    t.string   "compensation_type",             limit: 20
    t.string   "publication_status",            limit: 20
    t.string   "years_experience",              limit: 20
    t.string   "job_type",                      limit: 30
    t.string   "payment_type",                  limit: 20
    t.date     "fill_by"
    t.string   "languages"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "require_photo",                                                      default: false, null: false
    t.boolean  "require_video",                                                      default: false, null: false
    t.decimal  "compensation_range_low",                    precision: 11, scale: 2
    t.decimal  "compensation_range_high",                   precision: 11, scale: 2
    t.datetime "expiration"
    t.string   "custom_practice_software"
    t.boolean  "require_resume",                                                     default: false, null: false
    t.boolean  "require_recommendation_letter",                                      default: false, null: false
    t.index ["closed_job_reason_id"], name: "JobPosting_ClosedJobReason_reason_id_fk", using: :btree
    t.index ["company_id"], name: "job_table_company_id_foreign", using: :btree
    t.index ["job_position_id"], name: "job_table_position_foreign", using: :btree
  end

  create_table "job_postings_practice_management_systems", id: false, force: :cascade do |t|
    t.integer "job_posting_id",                null: false
    t.integer "practice_management_system_id", null: false
    t.index ["practice_management_system_id"], name: "jobPostingsPracticeManagementSystemId", using: :btree
  end

  create_table "job_postings_shift_configurations", force: :cascade do |t|
    t.integer  "job_posting_id",         null: false
    t.integer  "shift_configuration_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["job_posting_id"], name: "job_shifts_table_job_id_foreign", using: :btree
    t.index ["shift_configuration_id"], name: "JPSC_ShiftConfiguration_shiftConfigurationId_fk", using: :btree
  end

  create_table "job_postings_software_proficiencies", id: false, force: :cascade do |t|
    t.integer "job_posting_id",          null: false
    t.integer "software_proficiency_id", null: false
    t.index ["job_posting_id", "software_proficiency_id"], name: "ix_JobSoftwareProficiency", unique: true, using: :btree
    t.index ["software_proficiency_id"], name: "JobSoftwareProficiency_SoftwareProficiency_userId_fk", using: :btree
  end

  create_table "job_postings_views", force: :cascade do |t|
    t.integer  "job_posting_id", null: false
    t.integer  "user_id",        null: false
    t.datetime "view_time",      null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["job_posting_id"], name: "job_views_table_job_id_foreign", using: :btree
    t.index ["user_id"], name: "job_views_table_user_id_foreign", using: :btree
  end

  create_table "practice_management_systems", force: :cascade do |t|
    t.string   "software",       limit: 250
    t.string   "status",         limit: 1
    t.string   "visible_to",     limit: 200, default: "all", null: false
    t.string   "software_value", limit: 100
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "salary_configurations", force: :cascade do |t|
    t.string   "salary_name",  limit: 100
    t.string   "salary_value", limit: 100
    t.string   "status",       limit: 1
    t.datetime "created_at"
    t.datetime "updated_at"
    t.decimal  "range_high",               precision: 11, scale: 2
    t.decimal  "range_low",                precision: 11, scale: 2
  end

  create_table "sessions", force: :cascade do |t|
    t.string   "session_id", null: false
    t.text     "data"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["session_id"], name: "index_sessions_on_session_id", unique: true, using: :btree
    t.index ["updated_at"], name: "index_sessions_on_updated_at", using: :btree
  end

  create_table "shift_configurations", force: :cascade do |t|
    t.string "shift_days", limit: 255
    t.string "shift_time", limit: 255, null: false
  end

  create_table "software_proficiencies", force: :cascade do |t|
    t.string   "name",       limit: 250, null: false
    t.string   "value",      limit: 250
    t.string   "status",     limit: 1
    t.integer  "parent_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["parent_id"], name: "softwareProficiencyId_fk", using: :btree
  end

  create_table "stripe_event_logs", force: :cascade do |t|
    t.string   "customer_id"
    t.boolean  "livemode",                         null: false
    t.text     "data"
    t.string   "event_type"
    t.string   "request"
    t.integer  "pending_webhooks"
    t.string   "event_id"
    t.string   "note"
    t.boolean  "processed",        default: false, null: false
    t.datetime "created_at",                       null: false
    t.datetime "updated_at",                       null: false
  end

  create_table "user_certifications", force: :cascade do |t|
    t.integer  "user_id",                                             null: false
    t.string   "license_number",          limit: 200
    t.date     "license_expiry"
    t.string   "license_verified_states", limit: 250
    t.datetime "created_at"
    t.datetime "updated_at"
    t.boolean  "certified_by_board",                  default: false
    t.boolean  "license_verified",                    default: false, null: false
    t.index ["user_id"], name: "fk_user_id", using: :btree
  end

  create_table "users", force: :cascade do |t|
    t.string   "name",                       limit: 100
    t.string   "contact_name",               limit: 250
    t.string   "email",                      limit: 100,                 null: false
    t.string   "phone",                      limit: 255
    t.string   "photo",                      limit: 100
    t.string   "role",                       limit: 20
    t.text     "tagline"
    t.integer  "salary_configuration_id"
    t.text     "notes"
    t.string   "stripe_customer_id",         limit: 50
    t.string   "location_range",             limit: 20
    t.integer  "virtual_interview"
    t.string   "new_practice",               limit: 250
    t.string   "new_practice_software",      limit: 250
    t.string   "compensation_type",          limit: 20
    t.string   "years_experience",           limit: 20
    t.string   "work_availability",          limit: 30
    t.date     "available_for_work_on"
    t.string   "user_name",                  limit: 100
    t.string   "token",                      limit: 200
    t.datetime "token_expiration"
    t.string   "email_token",                limit: 250
    t.string   "email_verified",             limit: 100
    t.datetime "email_expiration"
    t.string   "user_type",                  limit: 100
    t.string   "new_email",                  limit: 100
    t.string   "previous_emails",            limit: 300
    t.string   "languages"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.string   "encrypted_password",                     default: "",    null: false
    t.string   "reset_password_token"
    t.datetime "reset_password_sent_at"
    t.datetime "remember_created_at"
    t.integer  "sign_in_count",                          default: 0,     null: false
    t.datetime "current_sign_in_at"
    t.datetime "last_sign_in_at"
    t.inet     "current_sign_in_ip"
    t.inet     "last_sign_in_ip"
    t.string   "confirmation_token"
    t.datetime "confirmed_at"
    t.datetime "confirmation_sent_at"
    t.string   "unconfirmed_email"
    t.string   "provider"
    t.string   "uid"
    t.integer  "affiliation_id"
    t.boolean  "blocked_access",                         default: false, null: false
    t.boolean  "accepted_terms",                         default: false, null: false
    t.boolean  "active",                                 default: true,  null: false
    t.boolean  "alerts",                                 default: false, null: false
    t.integer  "last_company_context_id"
    t.string   "profile_photo_file_name"
    t.string   "profile_photo_content_type"
    t.integer  "profile_photo_file_size"
    t.datetime "profile_photo_updated_at"
    t.index ["affiliation_id"], name: "index_users_on_affiliation_id", using: :btree
    t.index ["confirmation_token"], name: "index_users_on_confirmation_token", unique: true, using: :btree
    t.index ["email"], name: "index_users_on_email", unique: true, using: :btree
    t.index ["reset_password_token"], name: "index_users_on_reset_password_token", unique: true, using: :btree
    t.index ["salary_configuration_id"], name: "User_SalaryConfiguration_salary_id_fk", using: :btree
  end

  create_table "users_companies", id: false, force: :cascade do |t|
    t.integer "user_id",                    null: false
    t.integer "company_id",                 null: false
    t.boolean "blocked",    default: false, null: false
    t.index ["company_id"], name: "company_id", using: :btree
  end

  create_table "users_job_notifications", force: :cascade do |t|
    t.integer  "job_posting_id",                       null: false
    t.integer  "user_id",                              null: false
    t.string   "notification_description", limit: 250, null: false
    t.string   "viewed",                   limit: 100, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["job_posting_id"], name: "notifications_table_job_id_foreign", using: :btree
    t.index ["user_id"], name: "notifications_table_user_id_foreign", using: :btree
  end

  create_table "users_job_positions", force: :cascade do |t|
    t.integer  "user_id"
    t.integer  "job_position_id"
    t.datetime "created_at",      null: false
    t.datetime "updated_at",      null: false
  end

  create_table "users_job_types", force: :cascade do |t|
    t.integer  "user_id"
    t.string   "job_type"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "users_practice_management_systems", id: false, force: :cascade do |t|
    t.integer "user_id",                       null: false
    t.integer "practice_management_system_id", null: false
    t.index ["practice_management_system_id"], name: "usersPracticeManagementSystemId", using: :btree
  end

  create_table "users_shift_configurations", primary_key: "shift_configuration_id", force: :cascade do |t|
    t.integer  "user_id",    null: false
    t.datetime "created_at"
    t.datetime "updated_at"
    t.index ["user_id"], name: "UserShiftPreference_User_userId_fk", using: :btree
  end

  create_table "users_software_proficiencies", id: false, force: :cascade do |t|
    t.integer "user_id",                 null: false
    t.integer "software_proficiency_id", null: false
    t.index ["software_proficiency_id"], name: "UserSoftwareProficiency_SoftwareProficiency_userId_fk", using: :btree
    t.index ["user_id", "software_proficiency_id"], name: "ix_UserSoftwareProficiency", unique: true, using: :btree
  end

  create_table "zip_codes", force: :cascade do |t|
    t.float    "longitude"
    t.float    "latitude",               null: false
    t.string   "zip_code",   limit: 10,  null: false
    t.string   "city",       limit: 100, null: false
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_foreign_key "companies", "affiliations"
  add_foreign_key "companies", "users", column: "employer_user_id", name: "Company_User_userId_fk"
  add_foreign_key "companies_employee_benefits", "companies", name: "CompanyEmployeeBenefit_Company_companyId_fk"
  add_foreign_key "companies_employee_benefits", "employee_benefits", name: "CompanyEmployeeBenefit_EmployeeBenefit_companyId_fk"
  add_foreign_key "companies_practice_management_systems", "companies", name: "companies_practice_management_systems_ibfk_1", on_delete: :cascade
  add_foreign_key "companies_practice_management_systems", "practice_management_systems", name: "companies_practice_management_systems_ibfk_2", on_delete: :cascade
  add_foreign_key "company_locations", "companies", name: "CompanyLocation_Company_companyId_fk"
  add_foreign_key "device_tokens", "users", name: "DeviceToken_User_userId_fk"
  add_foreign_key "file_attachments", "companies", name: "FileAttachment_Company_companyId_fk"
  add_foreign_key "file_attachments", "users", name: "FileAttachment_User_userId_fk"
  add_foreign_key "job_applications", "job_postings", name: "UserJobStatus_JobPosting_jobPostingId_fk"
  add_foreign_key "job_applications", "users", name: "UserJobStatus_User_userId_fk"
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
  add_foreign_key "software_proficiencies", "software_proficiencies", column: "parent_id", name: "SoftwareProficiency_SoftwareProficiency_softwareProficiencyId_f"
  add_foreign_key "user_certifications", "users", name: "UserCertification_User_userId_fk"
  add_foreign_key "users", "affiliations"
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

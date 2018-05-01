class ConvertBooleanTypes < ActiveRecord::Migration[5.0]
  def up
    add_column :companies, :anonymous_company, :boolean, null: false, default: false
    add_column :companies, :anonymous_contact, :boolean, null: false, default: false
    add_column :job_applications, :employer_viewed, :boolean, null: false, default: false
    add_column :job_postings, :require_photo, :boolean, null: false, default: false
    add_column :job_postings, :require_video, :boolean, null: false, default: false
    add_column :user_certifications, :certified_by_board, :boolean, null: false, default: false
    add_column :users, :blocked_access, :boolean, null: false, default: false
    add_column :users, :accepted_terms, :boolean, null: false, default: false
    add_column :users, :active, :boolean, null: false, default: true

    Company.where(anonymous: 1).update_all anonymous_company: true
    Company.where(contact_anonymous: 1).update_all anonymous_contact: true
    JobApplication.where(viewed_by_employer: 1).update_all employer_viewed: true
    JobPosting.where(photo_required: 1).update_all require_photo: true
    JobPosting.where(video_required: 1).update_all require_video: true
    UserCertification.where(board_certified: 1).update_all certified_by_board: true
    User.where(blocked: 1).update_all blocked_access: true
    User.where(agree_to_terms: 1).update_all accepted_terms: true
    User.where(is_active: 0).update_all active: false

    remove_column :companies, :anonymous
    remove_column :companies, :contact_anonymous
    remove_column :job_applications, :viewed_by_employer
    remove_column :job_postings, :photo_required
    remove_column :job_postings, :video_required
    remove_column :user_certifications, :board_certified
    remove_column :users, :blocked
    remove_column :users, :agree_to_terms
    remove_column :users, :is_active
  end

  def down
    add_column :companies, :anonymous, :integer, null: false, default: 0
    add_column :companies, :contact_anonymous, :integer, null: false, default: 0
    add_column :job_applications, :viewed_by_employer, :integer, null: false, default: 0
    add_column :job_postings, :photo_required, :integer, null: false, default: 0
    add_column :job_postings, :video_required, :integer, null: false, default: 0
    add_column :user_certifications, :board_certified, :integer, null: false, default: 0
    add_column :users, :blocked, :integer, null: false, default: 0
    add_column :users, :agree_to_terms, :integer, null: false, default: 0
    add_column :users, :is_active, :integer, null: false, default: 1

    Company.where(anonymous_company: true).update_all anonymous: 1
    Company.where(anonymous_contact: true).update_all contact_anonymous: 1
    JobApplication.where(employer_viewed: true).update_all viewed_by_employer: 1
    JobPosting.where(require_photo: true).update_all photo_required: 1
    JobPosting.where(require_video: true).update_all video_required: 1
    UserCertification.where(certified_by_board: true).update_all board_certified: 1
    User.where(blocked_access: true).update_all blocked: 1
    User.where(accepted_terms: true).update_all agree_to_terms: 1
    User.where(active: true).update_all is_active: 0

    remove_column :companies, :anonymous_company
    remove_column :companies, :anonymous_contact
    remove_column :job_applications, :employer_viewed
    remove_column :job_postings, :require_photo
    remove_column :job_postings, :require_video
    remove_column :user_certifications, :certified_by_board
    remove_column :users, :blocked_access
    remove_column :users, :accepted_terms
    remove_column :users, :active
  end
end

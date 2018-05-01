class ConvertResumeOnJobPosting < ActiveRecord::Migration[5.0]
  def up
    add_column :job_postings, :require_resume, :boolean, null: false, default: false
    add_column :job_postings, :require_recommendation_letter, :boolean, null: false, default: false

    JobPosting.where(resume: 'Yes').update_all require_resume: true
    JobPosting.where(letter_of_recommendation: 'Yes').update_all require_recommendation_letter: true

    remove_column :job_postings, :resume
    remove_column :job_postings, :letter_of_recommendation
  end

  def down
    add_column :job_postings, :resume, :string
    add_column :job_postings, :letter_of_recommendation, :string

    JobPosting.where(require_resume: true).update_all resume: 'Yes'
    JobPosting.where(require_resume: false).update_all resume: 'No'

    JobPosting.where(require_recommendation_letter: true).update_all letter_of_recommendation: 'Yes'
    JobPosting.where(require_recommendation_letter: false).update_all letter_of_recommendation: 'No'

    remove_column :job_postings, :require_resume
    remove_column :job_postings, :require_recommendation_letter
  end
end

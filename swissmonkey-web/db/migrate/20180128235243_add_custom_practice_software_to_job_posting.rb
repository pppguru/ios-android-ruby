class AddCustomPracticeSoftwareToJobPosting < ActiveRecord::Migration[5.0]
  def change
    add_column :job_postings, :custom_practice_software, :string
  end
end

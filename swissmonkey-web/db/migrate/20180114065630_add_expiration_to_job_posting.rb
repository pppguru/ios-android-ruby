class AddExpirationToJobPosting < ActiveRecord::Migration[5.0]
  def change
    add_column :job_postings, :expiration, :datetime
  end
end

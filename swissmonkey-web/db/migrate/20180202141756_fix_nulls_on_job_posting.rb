class FixNullsOnJobPosting < ActiveRecord::Migration[5.0]
  def change
    change_column_null :job_postings, :logo, true
  end
end

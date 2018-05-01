class AddPrivateToClosedJobReason < ActiveRecord::Migration[5.0]
  def change
    add_column :closed_job_reasons, :private, :boolean, null: false, default: false
  end
end

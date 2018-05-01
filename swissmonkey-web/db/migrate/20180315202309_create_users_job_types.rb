class CreateUsersJobTypes < ActiveRecord::Migration[5.0]
  def change
    create_table :users_job_types do |t|
      t.integer :user_id
      t.string :job_type

      t.timestamps
    end

    remove_column :users, :job_type
  end
end

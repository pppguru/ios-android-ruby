class CreateUsersJobPositions < ActiveRecord::Migration[5.0]
  def up
    create_table :users_job_positions do |t|
      t.integer :user_id
      t.integer :job_position_id

      t.timestamps
    end

    User.where.not(job_position_id: nil).each do |user|
      user.job_positions << JobPosition.find(user.job_position_id)
    end

    remove_column :users, :job_position_id
  end

  def down
    add_column :users, :job_position_id, :integer
    User.all.each do |user|
      next unless user.job_positions.any?
      user.job_position_id = user.job_positions.first.id
      user.save
    end

    drop_table :users_job_positions
  end
end

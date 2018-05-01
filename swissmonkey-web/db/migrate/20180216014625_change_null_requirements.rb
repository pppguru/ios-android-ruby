class ChangeNullRequirements < ActiveRecord::Migration[5.0]
  def change
    change_column_null :salary_configurations, :salary_name, true
    change_column_null :salary_configurations, :salary_value, true
    change_column_null :salary_configurations, :status, true
    change_column_null :software_proficiencies, :value, true
    change_column_null :software_proficiencies, :status, true
    change_column_null :shift_configurations, :shift_days, true
    change_column_null :practice_management_systems, :software_value, true
    change_column_null :practice_management_systems, :software, true
    change_column_null :practice_management_systems, :status, true
    change_column_null :user_certifications, :certified_by_board, true
  end
end

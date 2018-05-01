class ChangeNullsOnCompany < ActiveRecord::Migration[5.0]
  def change
    change_column_null :companies, :name, false
    change_column_null :companies, :website, true
    change_column_null :companies, :digital_xray, true
    change_column_null :companies, :other_benefits, true
    change_column_null :companies, :number_of_operatories, true
    change_column_null :companies, :total_doctors, true
    change_column_null :companies, :length_of_appointment, true
    change_column_null :companies, :about, true
  end
end

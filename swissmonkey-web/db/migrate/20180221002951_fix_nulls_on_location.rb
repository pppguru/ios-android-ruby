class FixNullsOnLocation < ActiveRecord::Migration[5.0]
  def change
    change_column_null :company_locations, :address_line2, true
    change_column_null :addresses, :address_line2, true
  end
end

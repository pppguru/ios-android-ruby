class ChangeNullsOnAddress < ActiveRecord::Migration[5.0]
  def change
    change_column_null :addresses, :state, true
  end
end

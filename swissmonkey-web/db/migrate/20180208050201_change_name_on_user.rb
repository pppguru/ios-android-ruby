class ChangeNameOnUser < ActiveRecord::Migration[5.0]
  def change
    rename_column :users, :first_name, :name
    change_column_null :users, :name, true
  end
end

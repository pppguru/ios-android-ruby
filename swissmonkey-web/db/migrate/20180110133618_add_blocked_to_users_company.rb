class AddBlockedToUsersCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :users_companies, :blocked, :boolean, null: false, default: false
  end
end

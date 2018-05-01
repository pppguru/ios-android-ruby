class AddLastCompanyContextToUser < ActiveRecord::Migration[5.0]
  def change
    add_column :users, :last_company_context_id, :integer
  end
end

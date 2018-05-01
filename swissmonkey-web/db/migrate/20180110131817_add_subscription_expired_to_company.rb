class AddSubscriptionExpiredToCompany < ActiveRecord::Migration[5.0]
  def change
    add_column :companies, :subscription_expiration, :datetime
  end
end

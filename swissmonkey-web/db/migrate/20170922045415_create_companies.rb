class CreateCompanies < ActiveRecord::Migration[5.0]
  def change
    change_table :companies do |t|
      t.string :email, null: true
      t.string :stripe_customer_id
      t.string :stripe_subscription_id
      t.string :stripe_plan
      t.boolean :active, null: false, default: true
      t.boolean :trial, null: false, default: true
      t.datetime :trial_expiration
      t.datetime :initial_conversion_date, null: true
      t.boolean :pending_deactivation, null: false, default: false
      t.datetime :trial_expired_reminder_sent
      t.datetime :trial_expiring_reminder_sent
    end
  end
end

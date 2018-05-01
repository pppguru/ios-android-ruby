class MigrateAlertsOnUser < ActiveRecord::Migration[5.0]
  def up
    add_column :users, :alerts, :boolean, null: false, default: false
    User.where(alerts_enabled: 1).update_all alerts: true
    remove_column :users, :alerts_enabled
  end

  def down
    add_column :users, :alerts_enabled, :integer, null: false, default: 0
    User.where(alerts: true).update_all alerts_enabled: 1
    remove_column :users, :alerts
  end
end

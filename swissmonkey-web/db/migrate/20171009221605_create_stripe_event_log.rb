class CreateStripeEventLog < ActiveRecord::Migration[5.0]
  def change
    create_table :stripe_event_logs do |t|
      t.string :customer_id
      t.boolean :livemode, null: false
      t.text :data
      t.string :event_type
      t.string :request
      t.integer :pending_webhooks
      t.string :event_id
      t.string :note
      t.boolean :processed, default: false, null: false

      t.timestamps
    end
  end
end

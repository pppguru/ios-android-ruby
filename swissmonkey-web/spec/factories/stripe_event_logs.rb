# == Schema Information
#
# Table name: stripe_event_logs
#
#  id               :integer          not null, primary key
#  customer_id      :string
#  livemode         :boolean          not null
#  data             :text
#  event_type       :string
#  request          :string
#  pending_webhooks :integer
#  event_id         :string
#  note             :string
#  processed        :boolean          default(FALSE), not null
#  created_at       :datetime         not null
#  updated_at       :datetime         not null
#

FactoryGirl.define do
  factory :stripe_event_log do
    livemode false
  end
end

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

# Stores a record of every stripe webhook received.  Handles certain webhooks within the product
class StripeEventLog < ApplicationRecord
  serialize :data, Hash

  before_create :apply_webhook

  def customer_url
    if customer_id.present?
      if Rails.env.development?
        'https://dashboard.stripe.com/test/customers/' + customer_id
      else
        'https://dashboard.stripe.com/customers/' + customer_id
      end
    else
      '#'
    end
  end

  def request_url
    if request.present?
      if Rails.env.development?
        'https://dashboard.stripe.com/test/logs/' + request
      else
        'https://dashboard.stripe.com/logs/' + request
      end
    else
      '#'
    end
  end

  def company
    return if customer_id.blank?
    Company.find_by stripe_customer_id: customer_id
  end

  def company_id
    c = company
    if c.present?
      c.id
    else
      customer_id
    end
  end

  def company_name
    c = company
    if c.present?
      c.name
    else
      customer_id
    end
  end

  def apply_webhook
    case event_type
    when 'customer.subscription.deleted'
      subscription_id = data['object']['id']
      if company.present?
        if subscription_id == company.stripe_subscription_id
          company.deactivate!
          self.note = 'Deactivated account'
        end
      end
    end

    self.processed = true
  end

  def self.create_from_webhook(webhook)
    raise(ArgumentError, 'webhook must have a "data" property') if webhook['data'].blank?
    data = webhook['data']
    customer_id = data['object'].present? ? data['object']['customer'] : nil
    StripeEventLog.create! data: data,
                           customer_id: customer_id,
                           livemode: webhook['livemode'],
                           event_type: webhook['type'],
                           request: webhook['request'],
                           pending_webhooks: webhook['pending_webhooks'],
                           event_id: webhook['id']
  end
end

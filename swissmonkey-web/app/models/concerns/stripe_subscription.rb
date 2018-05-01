# Methods and hooks pertaining to stripe subscriptions.  This concern is used by the Company model
module StripeSubscription
  extend ActiveSupport::Concern

  included do
    before_create :ensure_customer_record
  end

  def subscribed?
    !trial? && stripe_subscription_id.present?
  end

  def default_card?
    stripe_customer.default_source.present?
  end

  def stripe_customer
    Stripe::Customer.retrieve(stripe_customer_id)
  end

  def stripe_invoices(limit = 20)
    cache_key = "stripe_invoices_#{self.class.name}_#{id}_#{limit}"
    APICache.get(cache_key, period: 10) do
      result = Stripe::Invoice.all(customer: stripe_customer_id, limit: limit)
      result.present? ? result.data : []
    end
  end

  def stripe_cards(limit = 20)
    result = stripe_customer.sources.all(object: 'card', limit: limit)
    result.present? ? result.data : []
  end

  def add_stripe_card(number, name, exp_month, exp_year, default = false)
    created_card = stripe_customer.sources.create(
      source: {
        object: 'card',
        number: number,
        name: name,
        exp_month: exp_month,
        exp_year: exp_year
      }
    )
    if default
      stripe_customer.default_source = created_card.id
      stripe_customer.save
    end

    created_card
  end

  def stripe_subscription
    customer = stripe_customer
    customer.subscriptions.data.first
  end

  # Find out if this user has an associated Stripe customer profile
  def payment_info?
    stripe_customer_id.present?
  end

  def ensure_customer_record
    return if payment_info? || name.blank? || email.blank?
    result = Stripe::Customer.create(
      description: name,
      email: email
    )
    self.stripe_customer_id = result.id
  end

  def apply_subscription(subscription_plan_key)
    return if stripe_customer_id.blank?

    if stripe_subscription_id.blank?
      create_stripe_subscription(subscription_plan_key)
    else
      update_stripe_subscription(subscription_plan_key)
    end

    update! active: true,
            trial: false,
            pending_deactivation: false,
            stripe_plan: subscription_plan_key

    self
  end

  private

  def create_stripe_subscription(subscription_plan_key)
    customer = stripe_customer
    subscription = customer.subscriptions.create(plan: subscription_plan_key.to_s, quantity: 1)
    update! stripe_subscription_id: subscription.id,
            initial_conversion_date: (initial_conversion_date || Time.zone.now)
  end

  def update_stripe_subscription(subscription_plan_key)
    subscription = stripe_customer.subscriptions.retrieve(stripe_subscription_id)
    subscription.plan = subscription_plan_key.to_s
    subscription.prorate = true
    subscription.quantity = 1
    subscription.save
  end
end

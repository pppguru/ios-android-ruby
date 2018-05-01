# Meta data for subscription tiers
class SubscriptionPlan
  attr_accessor :key
  attr_accessor :price
  attr_accessor :name

  def initialize(key, price, name)
    @key = key
    @price = price
    @name = name
  end

  def self.keys
    subscriptions.keys
  end

  def self.subscriptions
    {
      basic: SubscriptionPlan.new(:basic, 149.00, 'Basic'),
      free: SubscriptionPlan.new(:free, 0.00, 'Free')
    }
  end

  def self.find(key)
    subscription = subscriptions[key.to_sym]

    raise 'Subscription not found' unless subscription

    subscription
  end
end

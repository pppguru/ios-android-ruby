# Webhooks and methods that pertain to company free trials
module FreeTrial
  extend ActiveSupport::Concern

  included do
    scope :expiring_trials, lambda { |cutoff_date = nil|
      on_trial.where('trial_expiration BETWEEN ? and ?',
                     Time.zone.today, (cutoff_date || 7.days.from_now))
    }
    scope :current_trial_or_paying, -> { where '(trial = ? or trial_expiration > ?)', false, Time.zone.now }
    scope :on_trial, -> { where active: true, trial: true }
    scope :not_on_trial, -> { where trial: false }
    scope :trial_not_expired, -> { where 'trial_expiration > ?', Time.zone.now }
    scope :trial_expired, -> { where 'trial_expiration <= ?', Time.zone.now }
    scope :trial_expiring, -> { where 'trial_expiration BETWEEN ? AND ?', Time.zone.now, 7.days.from_now }
    scope :trial_expired_on_or_before, ->(date) { where 'trial_expiration <= ?', date }
    scope :trial_expired_between, lambda { |start_date, end_date|
      where 'trial_expiration BETWEEN ? AND ?', start_date, end_date
    }

    before_create :initialize_trial
  end

  def trial_expired?
    trial? && (trial_expiration < Time.zone.now)
  end

  private

  def initialize_trial
    self.trial_expiration = 14.days.from_now if trial_expiration.blank? && trial?
  end
end

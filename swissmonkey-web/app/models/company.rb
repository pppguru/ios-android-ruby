# == Schema Information
#
# Table name: companies
#
#  id                           :integer          not null, primary key
#  name                         :string(255)      not null
#  website                      :string(250)
#  length_of_appointment        :string(250)
#  total_doctors                :string(250)
#  number_of_operatories        :string(250)
#  about                        :text
#  digital_xray                 :string(100)
#  other_benefits               :string(250)
#  company_established          :string(250)
#  video_link                   :string(100)
#  employer_user_id             :integer
#  contact_name                 :string(200)
#  contact_email                :string(255)
#  contact_number               :string(255)
#  contact_private_number       :string(255)
#  created_at                   :datetime
#  updated_at                   :datetime
#  email                        :string
#  stripe_customer_id           :string
#  stripe_subscription_id       :string
#  stripe_plan                  :string
#  active                       :boolean          default(TRUE), not null
#  trial                        :boolean          default(TRUE), not null
#  trial_expiration             :datetime
#  initial_conversion_date      :datetime
#  pending_deactivation         :boolean          default(FALSE), not null
#  trial_expired_reminder_sent  :datetime
#  trial_expiring_reminder_sent :datetime
#  affiliation_id               :integer
#  anonymous_company            :boolean          default(FALSE), not null
#  anonymous_contact            :boolean          default(FALSE), not null
#  subscription_expiration      :datetime
#

# Represents a company that offers jobs
class Company < ApplicationRecord
  include FreeTrial
  include HasAffiliation
  include StripeSubscription

  has_many :job_postings, dependent: :destroy
  has_many :company_locations, dependent: :destroy
  has_many :file_attachments, dependent: :destroy
  has_many :users_companies, dependent: :destroy
  has_many :users, through: :users_companies, dependent: :nullify
  has_many :companies_employee_benefits, dependent: :destroy
  has_many :employee_benefits, through: :companies_employee_benefits, dependent: :nullify
  has_many :companies_practice_management_systems, dependent: :destroy
  has_many :practice_management_systems, through: :companies_practice_management_systems, dependent: :nullify

  belongs_to :employer_user, class_name: 'User'

  scope :active, -> { where active: true }
  scope :subscription_not_expired, lambda {
    where 'subscription_expiration IS NULL OR subscription_expiration > ?', Time.zone.now
  }
  scope :inactive, -> () { where(active: false) }
  scope :eligible_for_trial_reminder, lambda {
    active.trial_expired.where(trial_expired_reminder_sent: nil)
  }
  scope :eligible_for_trial_expiring_reminder, lambda {
    active.trial_expiring.where(trial_expiring_reminder_sent: nil)
  }
  scope :trial_active, -> () { where('trial = ? AND trial_expiration > ?', true, Time.zone.now) }
  scope :subscribed, lambda {
    where('stripe_plan IN (?) and (pending_deactivation IS NULL OR pending_deactivation = ?)', [:basic], false)
  }
  scope :not_blocked_for_user, lambda { |user|
    joins('users_companies').where('users_companies.user_id = ? AND users_companies.blocked = ?', user.id, false)
  }

  def self.excluded_from_search_results_for_user(user)
    joins('LEFT JOIN users_companies
            ON users_companies.company_id = companies.id')
      .where('active = ?
                OR subscription_expiration <= ?
                OR (users_companies.user_id = ? AND users_companies.blocked = ?)',
             false, Time.zone.now, user.id, true)
  end

  def primary_location
    company_locations.first
  end

  def anonymous?
    anonymous_company? || anonymous_contact?
  end

  def practice_management_systems_list
    practice_management_systems.map(&:software)
  end

  def benefits_list
    benefits_array = employee_benefits.map(&:name) || []
    benefits_array << other_benefits if other_benefits.present?

    benefits_array
  end

  def display_digital_xray
    if digital_xray == '1'
      'Yes'
    elsif digital_xray == '0'
      'No'
    else
      '-'
    end
  end

  def display_name
    anonymous? ? 'ANONYMOUS' : name
  end

  def display_website
    anonymous? ? 'ANONYMOUS' : website
  end

  def contact_display_email
    anonymous_contact? ? 'ANONYMOUS' : contact_email
  end

  def contact_display_name
    anonymous_contact? ? 'ANONYMOUS' : contact_name
  end

  def contact_display_phone
    anonymous_contact? ? 'ANONYMOUS' : contact_number
  end

  def deactivate!
    self.stripe_plan = nil
    self.stripe_subscription_id = nil
    self.pending_deactivation = false
    self.active = false
    save!
  end

  def account_status
    if cancelled?
      'Cancelled'
    elsif trial_expired?
      'Trial Expired'
    elsif active_trial?
      'Active Trial'
    elsif subscribed?
      'Subscribed'
    else
      'Error'
    end
  end

  def active_trial?
    trial? && (trial_expiration ? trial_expiration > Time.zone.now : false) && stripe_plan.blank?
  end

  def cancelled?
    !subscribed? && !pending_deactivation && !active && !trial && trial_expiration.nil?
  end

  def practice_photo_urls
    file_attachments&.practice_photos&.map do |file_attachment|
      file_attachment.file.url
    end
  end
end

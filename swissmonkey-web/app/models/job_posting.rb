# == Schema Information
#
# Table name: job_postings
#
#  id                            :integer          not null, primary key
#  job_position_id               :integer
#  job_description               :text
#  closed_job_reason_id          :integer
#  skype_interview               :string(100)      default("No"), not null
#  company_id                    :integer
#  logo                          :string(250)
#  company_location_id           :integer
#  compensation_type             :string(20)
#  publication_status            :string(20)
#  years_experience              :string(20)
#  job_type                      :string(30)
#  payment_type                  :string(20)
#  fill_by                       :date
#  languages                     :string
#  created_at                    :datetime
#  updated_at                    :datetime
#  require_photo                 :boolean          default(FALSE), not null
#  require_video                 :boolean          default(FALSE), not null
#  compensation_range_low        :decimal(11, 2)
#  compensation_range_high       :decimal(11, 2)
#  expiration                    :datetime
#  custom_practice_software      :string
#  require_resume                :boolean          default(FALSE), not null
#  require_recommendation_letter :boolean          default(FALSE), not null
#

# The core piece of Swiss Monkey - the job posting
class JobPosting < ApplicationRecord
  include EnumerationsHelper
  include LegacyHelper
  include WithExperience
  include WithJobType
  include WithShifts

  belongs_to :job_position
  belongs_to :company
  belongs_to :closed_job_reason, optional: true
  belongs_to :company_location
  has_many :job_applications, dependent: :destroy
  has_many :applications, through: :job_applications, class_name: 'User', dependent: :nullify
  has_many :job_postings_views, dependent: :destroy
  has_many :viewing_users, through: :job_postings_views, class_name: 'User', dependent: :nullify
  has_many :users_job_notifications, dependent: :destroy
  has_many :users_notified, through: :users_job_notifications, class_name: 'User', dependent: :nullify

  has_many :job_postings_practice_management_systems, dependent: :destroy
  has_many :practice_management_systems, through: :job_postings_practice_management_systems, dependent: :nullify
  has_many :job_postings_shift_configurations, dependent: :destroy
  has_many :shift_configurations, through: :job_postings_shift_configurations, dependent: :nullify
  has_many :job_postings_software_proficiencies, dependent: :destroy
  has_many :software_proficiencies, through: :job_postings_software_proficiencies, dependent: :nullify

  scope :by_companies, ->(company_ids) { where company_id: company_ids }

  def created_at_pretty
    created_at.to_formatted_s(:full_date)
  end

  def created_at_mysql_format
    created_at.to_formatted_s(:mysql_date_time_format)
  end

  def closed?
    publication_status == 'CLOSED'
  end

  def published?
    publication_status == 'PUBLISHED'
  end

  def practice_management_systems_names
    practice_management_systems.map(&:software).join(',')
  end

  def compensation_label
    compensation_type&.titleize || 'Not Specified'
  end

  def status_label
    publication_status&.titleize
  end

  def status_legacy
    case publication_status
    when 'UNPUBLISHED'
      1
    when 'PUBLISHED'
      2
    when 'CLOSED'
      3
    end
  end

  def compensation_range?
    compensation_range_low.present? && compensation_range_high.present? && compensation_range_low != 'Not Specified'
  end

  def skills_list
    skills = software_proficiencies.map(&:id)
    SoftwareProficiency.ordered_skills.map do |skill|
      skill.name_with_children(skills)
    end
  end

  def compensation_amount_label
    if compensation_range_low.present? && compensation_range_high.present? && compensation_range_low != 'Not Specified'
      "#{compensation_range_low}-$#{compensation_range_high}"
    else
      '(Not Specified)'
    end
  end

  def saved_status(user)
    user && JobApplication.where(user_id: user.id, job_posting_id: id, application_status: 'SAVED').any?
  end

  def expired?
    expiration.present? && expiration < Time.zone.now
  end

  def shift_for_day?(shift, day_of_week_index)
    day_of_week = days_of_week[day_of_week_index]

    configuration = shift_configurations.find_by(shift_time: shift)
    return false unless configuration

    configuration.shift_days.split(',').include?(day_of_week)
  end

  def rank_key
    "#{id}||#{job_position.name}||#{created_at.to_formatted_s(:mdy_with_time)}"
  end

  def send_new_application_text!
    return unless company.contact_private_number
    message_text = "New application received for #{job_position.name}! " \
                      'Review by signing in to the application (www.swissmonkey.co).'
    SwissMonkey::Sms.send(company.contact_private_number, message_text)
  end

  def best_email
    company.contact_email || company.employer_user&.email
  end
end

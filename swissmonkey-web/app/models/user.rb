# == Schema Information
#
# Table name: users
#
#  id                         :integer          not null, primary key
#  name                       :string(100)
#  contact_name               :string(250)
#  email                      :string(100)      not null
#  phone                      :string(255)
#  photo                      :string(100)
#  role                       :string(20)
#  tagline                    :text
#  salary_configuration_id    :integer
#  notes                      :text
#  stripe_customer_id         :string(50)
#  location_range             :string(20)
#  virtual_interview          :integer
#  new_practice               :string(250)
#  new_practice_software      :string(250)
#  compensation_type          :string(20)
#  years_experience           :string(20)
#  work_availability          :string(30)
#  available_for_work_on      :date
#  user_name                  :string(100)
#  token                      :string(200)
#  token_expiration           :datetime
#  email_token                :string(250)
#  email_verified             :string(100)
#  email_expiration           :datetime
#  user_type                  :string(100)
#  new_email                  :string(100)
#  previous_emails            :string(300)
#  languages                  :string
#  created_at                 :datetime
#  updated_at                 :datetime
#  encrypted_password         :string           default(""), not null
#  reset_password_token       :string
#  reset_password_sent_at     :datetime
#  remember_created_at        :datetime
#  sign_in_count              :integer          default(0), not null
#  current_sign_in_at         :datetime
#  last_sign_in_at            :datetime
#  current_sign_in_ip         :inet
#  last_sign_in_ip            :inet
#  confirmation_token         :string
#  confirmed_at               :datetime
#  confirmation_sent_at       :datetime
#  unconfirmed_email          :string
#  provider                   :string
#  uid                        :string
#  affiliation_id             :integer
#  blocked_access             :boolean          default(FALSE), not null
#  accepted_terms             :boolean          default(FALSE), not null
#  active                     :boolean          default(TRUE), not null
#  alerts                     :boolean          default(FALSE), not null
#  last_company_context_id    :integer
#  profile_photo_file_name    :string
#  profile_photo_content_type :string
#  profile_photo_file_size    :integer
#  profile_photo_updated_at   :datetime
#

# Represents a user that logs in
class User < ApplicationRecord
  include EnumerationsHelper
  include LegacyHelper
  include HasAffiliation
  include WithExperience
  include WithShifts

  # Others available are:
  # :lockable, :timeoutable

  devise :database_authenticatable, :registerable,
         :recoverable, :rememberable, :trackable, :validatable,
         #:confirmable, # :lockable, :timeoutable,
         :omniauthable, omniauth_providers: %i[facebook github google_oauth2 twitter]

  def self.create_from_provider_data(provider_data)
    where(provider: provider_data.provider, uid: provider_data.uid).first_or_create do |user|
      user.email = provider_data.info.email
      user.password = Devise.friendly_token[0, 20]
      # user.skip_confirmation!
    end
  end

  # belongs_to :job_position, optional: true
  belongs_to :salary_configuration, optional: true

  has_many :addresses, dependent: :destroy
  has_many :device_tokens, dependent: :destroy
  has_many :file_attachments, dependent: :destroy
  has_many :user_certifications, dependent: :destroy
  has_many :job_applications, dependent: :destroy
  has_many :job_postings, through: :job_applications
  has_many :job_postings_views, foreign_key: :user_id
  has_many :viewed_job_postings, through: :job_postings_views, source: :job_posting
  has_many :users_job_notifications
  has_many :job_notifications, through: :users_job_notifications, source: :job_posting
  has_many :users_companies
  has_many :companies, through: :users_companies
  has_many :users_practice_management_systems
  has_many :practice_management_systems, through: :users_practice_management_systems
  has_many :users_shift_configurations
  has_many :shift_configurations, through: :users_shift_configurations
  has_many :users_software_proficiencies
  has_many :software_proficiencies, through: :users_software_proficiencies
  has_many :users_job_positions
  has_many :job_positions, through: :users_job_positions
  has_many :users_job_types, dependent: :destroy

  belongs_to :last_company_context, class_name: 'Company'

  scope :employers, -> { where role: 'EMPLOYER' }
  scope :job_seekers, -> { where role: 'JOBSEEKER' }

  has_attached_file :profile_photo, styles: {
    large: '800x800#',
    thumbnail: '400x400#'
  },
                                    storage: :s3,
                                    s3_protocol: 'https',
                                    s3_region: ENV['AWS_S3_REGION'],
                                    s3_credentials: {
                                      s3_region: ENV['AWS_S3_REGION'],
                                      bucket: ENV['AWS_S3_BUCKET'],
                                      access_key_id: ENV['AWS_ACCESS_KEY_ID'],
                                      secret_access_key: ENV['AWS_ACCESS_KEY_SECRET']
                                    },
                                    s3_host_name: 's3.amazonaws.com',
                                    path: '/:class/:attachment/:id_partition/:style/:filename'
  validates_attachment_content_type :profile_photo, content_type: %r{\Aimage/.*\Z}

  def self.authenticate!(username, password)
    return nil if username.blank? || password.blank?

    if (user = User.find_by(email: username))
      return user if user.valid_password?(password)
    end

    nil
  end

  def job_position
    job_positions.first
  end

  def phone_formatted
    phone # TODO: make this work
  end

  def company_ids
    companies.map(&:id)
  end

  def location_range_numeric
    miles_range_to_numeric(location_range)
  end

  def auth_token
    require 'digest/md5'
    Digest::MD5.hexdigest(email)
  end

  def employer?
    role == 'EMPLOYER'
  end

  def job_seeker?
    role == 'JOBSEEKER'
  end

  def profile_pic?
    profile_photo.present? || file_attachments.profile_pics.any?
  end

  def profile_pic
    profile_photo.present? ? profile_photo.url(:thumbnail) : file_attachments.profile_pics.first&.file&.url
  end

  def profile_pic_filename
    profile_photo_file_name || file_attachments.profile_pics.first&.filename
  end

  def resume?
    file_attachments.resumes.any?
  end

  delegate :resumes, to: :file_attachments

  def application_hash
    {
      user_email: email,
      profile_pic: profile_pic,
      user_position_name: job_position&.name,
      salary: salary_configuration&.salary_value || 'NA',
      user_contact: phone || 'NA',
      address: addresses.first&.to_s || 'NA',
      job_seeker_name: name,
      experience: years_experience || 'NA'
    }
  end

  def new_previous_emails_string
    previous_emails ? previous_emails + ',' + email : email
  end

  def promote_new_email!
    update_hash = {
      previous_emails: new_previous_emails_string,
      user_name: new_email,
      token: Digest::MD5.hexdigest(new_email),
      new_email: nil,
      email: new_email
    }
    update! update_hash

    return unless employer?
    Company.where(employer_user_id: user.id).find_each { |c| c.update contact_email: new_email }
  end

  def job_types
    @job_types ||= users_job_types.map(&:job_type)
  end
end

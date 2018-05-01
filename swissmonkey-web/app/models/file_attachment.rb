# == Schema Information
#
# Table name: file_attachments
#
#  id                :integer          not null, primary key
#  attachment_type   :string(100)      not null
#  name              :string(250)
#  sort_order        :integer          default(0), not null
#  user_id           :integer          not null
#  status            :string(1)
#  company_id        :integer
#  created_at        :datetime
#  updated_at        :datetime
#  file_file_name    :string
#  file_content_type :string
#  file_file_size    :integer
#  file_updated_at   :datetime
#  uses_paperclip    :boolean          default(FALSE), not null
#  thumbnail         :string
#

# Represents a file attached to a user
class FileAttachment < ApplicationRecord
  include WithLegacyMedia

  belongs_to :user
  belongs_to :company

  has_attached_file :file,
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
  do_not_validate_attachment_file_type :file

  scope :resumes, -> { where attachment_type: 'resume' }
  scope :video, -> { where attachment_type: %w[video videoFiles] }
  scope :images, -> { where attachment_type: %w[image imgFiles] }
  scope :recommendation_letters, -> { where attachment_type: %w[recommendationletters recommendationLetters] }
  scope :thumbnails, -> { where attachment_type: 'thumbnail' }
  scope :profile_pics, -> { where attachment_type: 'profile' }
  scope :practice_photos, -> { where attachment_type: 'practicephotos' }

  def s3_object_id
    s3_object_id_from_attachment(attachment_type, name)
  end

  def convert_to_paperclip!
    return if file.present?
    return if s3_object_id.blank?

    obj = s3_object
    extension = file_extension(s3_object, name)

    converted_name = extension.present? ? "converted.#{extension}" : 'converted'

    self.file = FileAttachment.string_to_file(converted_name, obj.content_type, obj.body.read)
    save
  end

  def filename
    uses_paperclip? ? file_file_name : name
  end

  def url
    if uses_paperclip?
      file.url
    else
      s3 = Aws::S3::Resource.new(region: ENV['AWS_S3_REGION'])
      bucket = s3.bucket(ENV['AWS_S3_BUCKET'])
      object = bucket.object(s3_object_id)
      object&.public_url
    end
  end

  def self.string_to_file(name, type, data)
    file = StringIO.new(data)
    file.class.class_eval { attr_accessor :original_filename, :content_type }
    file.original_filename = name
    file.content_type = type
    file
  end
end

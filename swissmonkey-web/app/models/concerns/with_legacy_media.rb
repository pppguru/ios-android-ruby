# Used by FileAttachment and Media
module WithLegacyMedia
  extend ActiveSupport::Concern

  def s3_object_id_from_attachment(attachment_type, name)
    path_base = prefix_map[attachment_type]
    "#{path_base}/#{name}"
  end

  def s3_object
    s3 = Aws::S3::Client.new
    s3.get_object(key: s3_object_id, bucket: ENV['AWS_S3_BUCKET'])
  end

  def prefix_map
    {
      'image' => 'images',
      'video' => 'videos',
      'videoFiles' => 'videos',
      'imgFiles' => 'images',
      'recommendationletters' => 'recommendatioLetters',
      'profile' => 'profileimages',
      'resume' => 'resume',
      'practicephotos' => 'practicephotos',
      'thumbnail' => 'thumbnail'
    }
  end

  def file_extension(s3_object, name)
    split_name = name.split('.')
    case s3_object.content_type
    when 'image/jpeg'
      'jpg'
    when 'image/png'
      'png'
    when 'image/gif'
      'gif'
    else
      split_name.last if split_name.present? && split_name.length > 1
    end
  end
end

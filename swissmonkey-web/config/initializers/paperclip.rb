# Amazon S3 settings for Paperclip uploads
Rails.application.config.paperclip_defaults = {
  storage: :s3,
  s3_protocol: 'https',
  s3_region: ENV['AWS_S3_REGION'],
  s3_credentials: {
    s3_region: ENV['AWS_S3_REGION'],
    bucket: ENV['AWS_S3_BUCKET'],
    access_key_id: ENV['AWS_ACCESS_KEY_ID'],
    secret_access_key: ENV['AWS_ACCESS_KEY_SECRET']
  },
  s3_host_name:  "s3-#{ENV['AWS_S3_REGION']}.amazonaws.com",
  path: '/:class/:attachment/:id_partition/:style/:filename'
}

# Paperclip (improperly) identifies *.vtt files as content type "text/plain", so let's allow that.
Paperclip.options[:content_type_mappings] = {
  vtt: %w[text/vtt text/plain application/octet-stream]
}

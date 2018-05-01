require 'aws-sdk'

Aws.config.update(
  region: ENV['AWS_S3_REGION'],
  credentials: Aws::Credentials.new(ENV['AWS_ACCESS_KEY_ID'], ENV['AWS_ACCESS_KEY_SECRET'])
)
s3 = Aws::S3::Resource.new(region: ENV['AWS_S3_REGION'])
S3_BUCKET = s3.bucket(ENV['AWS_S3_BUCKET']).object(SecureRandom.uuid)

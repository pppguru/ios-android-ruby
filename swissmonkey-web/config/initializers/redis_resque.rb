# Establish a connection between Resque and Redis
if Rails.env.staging? || Rails.env.production?
  uri = URI.parse ENV['REDIS_URL']
  Redis.current = Redis.new(host: uri.host, port: uri.port, password: uri.password)
elsif Rails.env.test?
  Redis.current = Redis.new
else
  Redis.current = Redis.new(host: 'localhost', port: 6379)
end

Resque.redis = Redis.current

# Base mailer class
class ApplicationMailer < ActionMailer::Base
  default from: 'noreply@swissmonkey.co'
  layout 'mailer'
end

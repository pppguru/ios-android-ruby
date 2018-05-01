# User-facing account related emails
class UserMailer < ApplicationMailer
  def welcome(email, token)
    @token = token

    mail to: email
  end

  def password(email, token)
    @token = token

    mail to: email
  end

  def change_email(email, new_email)
    @new_email = new_email

    mail to: email
  end
end

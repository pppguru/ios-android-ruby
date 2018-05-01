module SwissMonkey
  # Interfaces with Twilio
  class Sms
    def self.send(to_phone_number, message)
      to_phone_number = '9162204715' unless Rails.env.production? || Rails.env.test?
      return if to_phone_number.blank?

      twilio_number = ENV['TWILIO_NUMBER']
      country_code = ENV['COUNTRY_CODE']
      account_sid = ENV['TWILIO_ACCOUNT_SID']
      auth_token = ENV['TWILIO_AUTH_TOKEN']

      # set up a client to talk to the Twilio REST API
      @client = Twilio::REST::Client.new account_sid, auth_token

      @client.messages.create(from: twilio_number, to: "#{country_code}#{to_phone_number}", body: message)
      # rescue => ex
      #   Airbrake.notify ex
    end
  end
end

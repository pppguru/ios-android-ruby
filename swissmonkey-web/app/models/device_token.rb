# == Schema Information
#
# Table name: device_tokens
#
#  id          :integer          not null, primary key
#  token       :string(250)      not null
#  user_id     :integer          not null
#  device_type :string(255)      default("iOS"), not null
#  created_at  :datetime
#  updated_at  :datetime
#

# Used for push notifications to iOS or Android devies
class DeviceToken < ApplicationRecord
  belongs_to :user

  def ios?
    device_type == 'iOS'
  end

  def android?
    device_type == 'android'
  end

  def send_push(result)
    messages = PushNotification::Message(message, 'content-available' => 1,
                                                  'custom' => { 'notification data' => result.to_json })
    if ios?
      PushNotification.app('appNameIOS').to(token).send(messages)
    elsif android?
      PushNotification.app('appNameAndroid').to(token).send(result.to_json)
    end
  end
end

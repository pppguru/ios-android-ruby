json.success do
  json.array!(@notifications) do |notification|
    json.id notification.id
    json.job_posting_id notification.job_posting_id
    json.user_id notification.user_id
    json.notification_description notification.notification_description
    json.viewed notification.viewed
    json.created_at notification.created_at.to_formatted_s(:mysql_date_time_format)
    json.updated_at notification.updated_at.to_formatted_s(:mysql_date_time_format)
  end
end

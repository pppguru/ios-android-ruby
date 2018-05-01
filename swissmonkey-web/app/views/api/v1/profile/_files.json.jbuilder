json.files do
  json.array!(files) do |file_attachment|
    json.id file_attachment.id
    json.url file_attachment.url
    json.filename file_attachment.filename
    json.type file_attachment.attachment_type
  end
end

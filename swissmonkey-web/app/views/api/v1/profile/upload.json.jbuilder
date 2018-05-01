json.partial! 'api/v1/profile/files', files: current_user.file_attachments
json.profile_photo current_user.profile_pic

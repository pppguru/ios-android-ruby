class AddAttachmentToFileAttachment < ActiveRecord::Migration[5.0]
  def up
    add_attachment :file_attachments, :file
  end

  def down
    remove_attachment :file_attachments, :file
  end
end

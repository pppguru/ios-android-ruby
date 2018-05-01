class AddUsesPaperclipToMedia < ActiveRecord::Migration[5.0]
  def change
    add_column :media, :uses_paperclip, :boolean, null: false, default: false
    add_column :file_attachments, :uses_paperclip, :boolean, null: false, default: false
  end
end

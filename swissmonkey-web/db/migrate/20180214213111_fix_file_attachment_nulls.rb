class FixFileAttachmentNulls < ActiveRecord::Migration[5.0]
  def change
    change_column_null :file_attachments, :name, true
    change_column_null :file_attachments, :status, true
    change_column_default :file_attachments, :sort_order, from: nil, to: 0
    change_column_null :file_attachments, :company_id, true
  end
end

class AddAttachmentToMedia < ActiveRecord::Migration[5.0]
  def up
    add_attachment :media, :attachment
  end

  def down
    remove_attachment :media, :attachment
  end
end

class MoveMediaToFileAttachment < ActiveRecord::Migration[5.0]
  def up
    add_column :file_attachments, :thumbnail, :string

    sql = 'INSERT INTO file_attachments (
            name, sort_order, attachment_type, user_id, thumbnail, created_at, updated_at,
            file_file_name, file_content_type, file_file_size, file_updated_at,
            uses_paperclip
          )
          SELECT file, sort_order, file_type, user_id, thumbnail, created_at, updated_at,
                 attachment_file_name, attachment_content_type, attachment_file_size, attachment_updated_at,
                 uses_paperclip
          FROM media'
    ActiveRecord::Base.connection.execute sql

    drop_table :media
  end

  def down
    create_table "media", force: :cascade do |t|
      t.string   "file",                    limit: 250,                  null: false
      t.integer  "sort_order",                                           null: false
      t.string   "file_type",               limit: 100,                  null: false
      t.integer  "user_id",                                              null: false
      t.string   "thumbnail",               limit: 2000
      t.datetime "created_at"
      t.datetime "updated_at"
      t.string   "attachment_file_name"
      t.string   "attachment_content_type"
      t.integer  "attachment_file_size"
      t.datetime "attachment_updated_at"
      t.boolean  "uses_paperclip",                       default: false, null: false
      t.index ["user_id"], name: "media_table_jobseeker_id_foreign", using: :btree
    end

    sql = "INSERT INTO media (
            file, sort_order, file_type, user_id, thumbnail, created_at, updated_at,
                 attachment_file_name, attachment_content_type, attachment_file_size, attachment_updated_at,
                 uses_paperclip
          )
          SELECT name, sort_order, attachment_type, user_id, thumbnail, created_at, updated_at,
            file_file_name, file_content_type, file_file_size, file_updated_at,
            uses_paperclip
          FROM file_attachments WHERE attachment_type IN ('image', 'video')"
    ActiveRecord::Base.connection.execute sql

    sql = "DELETE FROM file_attachments WHERE attachment_type IN ('image', 'video')"
    ActiveRecord::Base.connection.execute sql

    remove_column :file_attachments, :thumbnail
  end
end

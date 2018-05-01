namespace :migration do
  desc 'Migrates file attachments'
  task file_attachments: :environment do
    FileAttachment.where(file_file_name: nil).each do |file_attachment|
      puts "Migrating #{file_attachment.id} #{file_attachment.name}"
      file_attachment.convert_to_paperclip!
      puts file_attachment.file.url
    end
  end

  desc 'Migrates media'
  task media: :environment do
    Media.where(attachment_file_name: nil).each do |media|
      begin
        puts "Migrating #{media.id} #{media.file}"
        media.convert_to_paperclip!
        puts media.attachment.url
      rescue Aws::S3::Errors::NoSuchKey
        puts 'No such key error'
      end
    end
  end
end

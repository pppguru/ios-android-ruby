# == Schema Information
#
# Table name: file_attachments
#
#  id                :integer          not null, primary key
#  attachment_type   :string(100)      not null
#  name              :string(250)
#  sort_order        :integer          default(0), not null
#  user_id           :integer          not null
#  status            :string(1)
#  company_id        :integer
#  created_at        :datetime
#  updated_at        :datetime
#  file_file_name    :string
#  file_content_type :string
#  file_file_size    :integer
#  file_updated_at   :datetime
#  uses_paperclip    :boolean          default(FALSE), not null
#  thumbnail         :string
#

FactoryGirl.define do
  factory :file_attachment do
  end
end

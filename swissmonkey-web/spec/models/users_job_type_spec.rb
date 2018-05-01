# == Schema Information
#
# Table name: users_job_types
#
#  id         :integer          not null, primary key
#  user_id    :integer
#  job_type   :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe UsersJobType, type: :model do
  it { should belong_to(:user) }
end

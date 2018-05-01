# == Schema Information
#
# Table name: users_job_positions
#
#  id              :integer          not null, primary key
#  user_id         :integer
#  job_position_id :integer
#  created_at      :datetime         not null
#  updated_at      :datetime         not null
#

require 'rails_helper'

RSpec.describe UsersJobPosition, type: :model do
  pending "add some examples to (or delete) #{__FILE__}"
end

# == Schema Information
#
# Table name: affiliations
#
#  id         :integer          not null, primary key
#  name       :string
#  created_at :datetime         not null
#  updated_at :datetime         not null
#

require 'rails_helper'

RSpec.describe Affiliation, type: :model do
  it { should have_many(:companies) }
  it { should have_many(:users) }

  it 'should clear associations after delete' do
    affiliation = FactoryGirl.create(:affiliation)
    company = FactoryGirl.create(:company, affiliation_id: affiliation.id)
    user = FactoryGirl.create(:user, affiliation_id: affiliation.id)

    affiliation.destroy
    expect(company.reload.affiliation_id).to be_nil
    expect(user.reload.affiliation_id).to be_nil
  end
end

class AddAffiliationReferenceToCompany < ActiveRecord::Migration[5.0]
  def change
    add_reference :companies, :affiliation, foreign_key: true, null: true
    add_reference :users, :affiliation, foreign_key: true, null: true
  end
end

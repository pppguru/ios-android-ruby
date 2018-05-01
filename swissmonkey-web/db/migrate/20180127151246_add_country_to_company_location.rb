class AddCountryToCompanyLocation < ActiveRecord::Migration[5.0]
  def change
    add_column :company_locations, :country, :string
  end
end

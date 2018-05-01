class AddLicenseVerifiedToUserCertification < ActiveRecord::Migration[5.0]
  def up
    add_column :user_certifications, :license_verified, :boolean, null: false, default: false
    UserCertification.where(verified: 1).update_all license_verified: true
    remove_column :user_certifications, :verified
  end

  def down
    add_column :user_certifications, :verified, :string
    UserCertification.where(license_verified: true).update_all verified: 1
    UserCertification.where(license_verified: false).update_all verified: 0
    remove_column :user_certifications, :license_verified
  end
end

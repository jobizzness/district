class ChangeLogoToLogoOldInCompanies < ActiveRecord::Migration
  def change
    rename_column :companies, :logo, :logo_old
  end
end

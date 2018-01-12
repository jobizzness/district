class ChangeAvatarToAvatarOldInCompanies < ActiveRecord::Migration
  def change
    rename_column :companies, :avatar, :avatar_old
  end
end

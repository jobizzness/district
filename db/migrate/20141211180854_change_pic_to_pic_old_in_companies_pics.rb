class ChangePicToPicOldInCompaniesPics < ActiveRecord::Migration
  def change
    rename_column :companies_pics, :pic, :pic_old
  end
end

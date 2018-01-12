class ChangePicToPicOldInCategories < ActiveRecord::Migration
  def change
    rename_column :categories, :pic, :pic_old
  end
end

class ChangePicToPicOldInArticles < ActiveRecord::Migration
  def change
    rename_column :articles, :pic, :pic_old
  end
end

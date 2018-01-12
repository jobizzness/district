class ChangePicToPicOldInArticlesCats < ActiveRecord::Migration
  def change
    rename_column :articles_cats, :pic, :pic_old
  end
end

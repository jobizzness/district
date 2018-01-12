class ChangePathToPathOldInArticlesPics < ActiveRecord::Migration
  def change
    rename_column :articles_pics, :path, :path_old
  end
end

class RemovePicOldFromArticlesCat < ActiveRecord::Migration
  def change
    remove_column :articles_cats, :pic_old, :string
  end
end

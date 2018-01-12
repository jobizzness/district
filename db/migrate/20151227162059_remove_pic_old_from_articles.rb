class RemovePicOldFromArticles < ActiveRecord::Migration
  def change
    remove_column :articles, :pic_old, :string
  end
end

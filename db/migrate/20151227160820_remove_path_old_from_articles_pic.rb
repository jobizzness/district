class RemovePathOldFromArticlesPic < ActiveRecord::Migration
  def change
    remove_column :articles_pics, :path_old, :string
  end
end

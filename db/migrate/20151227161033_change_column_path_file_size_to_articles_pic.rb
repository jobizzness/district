class ChangeColumnPathFileSizeToArticlesPic < ActiveRecord::Migration
  def change
    change_column :articles_pics, :path_file_size, :integer
  end
end

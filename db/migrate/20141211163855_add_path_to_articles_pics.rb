class AddPathToArticlesPics < ActiveRecord::Migration
  def change
    add_column :articles_pics, :path_file_name, :string
    add_column :articles_pics, :path_file_size, :string
    add_column :articles_pics, :path_content_type, :string
  end
end

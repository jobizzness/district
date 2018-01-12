class AddPicToArticlesCats < ActiveRecord::Migration
  def change
    add_column :articles_cats, :pic_file_name, :string
    add_column :articles_cats, :pic_file_size, :string
    add_column :articles_cats, :pic_content_type, :string
  end
end

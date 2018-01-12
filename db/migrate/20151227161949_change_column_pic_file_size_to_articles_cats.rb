class ChangeColumnPicFileSizeToArticlesCats < ActiveRecord::Migration
  def change
    change_column :articles_cats, :pic_file_size, :integer
  end
end

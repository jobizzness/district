class ChangeColumnPicFileSizeToArticles < ActiveRecord::Migration
  def change
    change_column :articles, :pic_file_size, :integer
  end
end

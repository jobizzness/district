class AddPicToCategories < ActiveRecord::Migration
  def change
    add_column :categories, :pic_file_name, :string
    add_column :categories, :pic_file_size, :string
    add_column :categories, :pic_content_type, :string
  end
end

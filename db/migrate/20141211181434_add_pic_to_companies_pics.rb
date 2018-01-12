class AddPicToCompaniesPics < ActiveRecord::Migration
  def change
    add_column :companies_pics, :pic_file_name, :string
    add_column :companies_pics, :pic_file_size, :string
    add_column :companies_pics, :pic_content_type, :string
  end
end

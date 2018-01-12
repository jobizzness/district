class AddPicToPress < ActiveRecord::Migration
  def change
    add_column :press, :pic_file_name, :string
    add_column :press, :pic_file_size, :string
    add_column :press, :pic_content_type, :string
  end
end

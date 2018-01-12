class AddAvatarToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :avatar_file_name, :string
    add_column :companies, :avatar_file_size, :string
    add_column :companies, :avatar_content_type, :string

#    remove_column :companies, :avatar
  end
end

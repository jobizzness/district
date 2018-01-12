class AddLogoToCompanies < ActiveRecord::Migration
  def change
    add_column :companies, :logo_file_name, :string
    add_column :companies, :logo_file_size, :string
    add_column :companies, :logo_content_type, :string

#    remove_column :companies, :logo
  end
end

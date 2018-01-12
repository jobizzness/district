class ChangeColumnsInCompaniesSubcategoriesConnections < ActiveRecord::Migration
  def change
    rename_column :companies_subcategories_connections, :id_company, :company_id
    rename_column :companies_subcategories_connections, :id_subcategory, :subcategory_id
  end
end

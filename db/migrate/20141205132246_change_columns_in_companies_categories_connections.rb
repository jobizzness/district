class ChangeColumnsInCompaniesCategoriesConnections < ActiveRecord::Migration
  def change
    rename_column :companies_categories_connections, :id_company, :company_id
    rename_column :companies_categories_connections, :id_category, :category_id
  end
end

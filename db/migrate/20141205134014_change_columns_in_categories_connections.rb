class ChangeColumnsInCategoriesConnections < ActiveRecord::Migration
  def change
    rename_column :categories_connections, :id_category, :category_id
    rename_column :categories_connections, :id_subcategory, :subcategory_id
  end
end

class ChangeTypeInSubcategories < ActiveRecord::Migration
  def change
    rename_column :subcategories, :type, :type_id
  end
end

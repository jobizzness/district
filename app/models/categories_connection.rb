class CategoriesConnection < ActiveRecord::Base
  belongs_to :category, class_name: 'Category', foreign_key: 'category_id'
  belongs_to :subcategory, class_name: 'Subcategory', foreign_key: 'subcategory_id'
end

class CompaniesCategoriesConnection < ActiveRecord::Base
  belongs_to :company, class_name: 'Company', foreign_key: 'company_id'
  belongs_to :category, class_name: 'Category', foreign_key: 'category_id'  
end

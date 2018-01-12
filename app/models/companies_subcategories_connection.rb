class CompaniesSubcategoriesConnection < ActiveRecord::Base
  belongs_to :company, class_name: 'Company', foreign_key: 'company_id'
  belongs_to :subcategory, class_name: 'Subcategory', foreign_key: 'subcategory_id'  
end

class CompaniesTagsConnection < ActiveRecord::Base  
  belongs_to :company, class_name: 'Company', foreign_key: 'id_company'
  belongs_to :tag, class_name: 'Tag', foreign_key: 'id_tag' 
end

class ArticlesCompaniesConnection < ActiveRecord::Base
  belongs_to :article, class_name: 'Article', foreign_key: 'id_article'
  belongs_to :company, class_name: 'Company', foreign_key: 'id_company'
end

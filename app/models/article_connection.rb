class ArticleConnection < ActiveRecord::Base
  self.table_name = 'articles_connections'
  belongs_to :article, class_name: 'Article', foreign_key: 'id_article2'
end

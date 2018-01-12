class Tag < ActiveRecord::Base
  has_many :tags_connections, foreign_key: 'id_tag'
  has_many :articles, through: :tags_connections

  has_many :companies_tags_connections, foreign_key: 'id_tag'
  has_many :companies, through: :companies_tags_connections
end

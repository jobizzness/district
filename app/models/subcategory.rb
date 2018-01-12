class Subcategory < ActiveRecord::Base
  has_many :categories_connections
  has_many :categories, through: :categories_connections

  has_many :companies_subcategories_connections
  has_many :companies, through: :companies_subcategories_connections
end

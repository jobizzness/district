class Category < ActiveRecord::Base
  has_many :companies_categories_connections
  has_many :companies, through: :companies_categories_connections

  has_many :categories_connections
  has_many :subcategories, through: :categories_connections

  has_attached_file :pic, default_url: '/categories/:style/missing.png'
  validates_attachment :pic, :presence => true, :content_type => { :content_type => /\Aimage\/.*\Z/ }
end

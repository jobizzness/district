class Article < ActiveRecord::Base
  include Bootsy::Container
  
  belongs_to :article_cat, class_name: 'ArticlesCat', foreign_key: 'parent'

  has_many :article_connections, foreign_key: 'id_article1'
  has_many :articles, through: :article_connections

  has_many :articles_companies_connections, foreign_key: 'id_article'
  has_many :companies, through: :articles_companies_connections

  has_many :tags_connections, foreign_key: 'id_article'
  has_many :tags, through: :tags_connections

  has_many :pics, class_name: 'ArticlesPic', foreign_key: 'parent', dependent: :destroy
  accepts_nested_attributes_for :pics, allow_destroy: true

  has_attached_file :pic, styles: { small: '262x175#',
                                    medium: '600x280#',
                                    social: '200x200#' },
                          default_url: '/articles/:style/missing.png'

  validates_attachment :pic, presence: true,
                             content_type: { content_type: ["image/tiff" ,"image/jpeg", "image/gif", "image/png", "application/pdf"] },
                             size: { less_than: 3.megabyte }

  validates_presence_of :title, :text_short, :text, :date, :anchor, :parent, :priv
end

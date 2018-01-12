class ArticlesCat < ActiveRecord::Base
  has_many :articles, foreign_key: 'parent', dependent: :destroy

  has_attached_file :pic, styles: { small: '35x79#' },
                          default_url: '/articles_cats/:style/missing.png'

  validates_attachment :pic, presence: true,
                             content_type: { content_type:["image/tiff" ,"image/jpeg", "image/gif", "image/png", "application/pdf"] },
                             size: { less_than: 3.megabyte }

  validates_presence_of :title, :text, :anchor, :priv
end

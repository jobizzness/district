class ArticlesPic < ActiveRecord::Base
  belongs_to :article, foreign_key: 'parent'

  has_attached_file :path, styles: { big: '1264x440',
                                     small: '262x175#',
                                     vsm: '50x50' },
                           default_url: '/articles_pics/:style/missing.png'

  validates_attachment :path, presence: true,
                              content_type: { content_type: ["image/tiff", "image/jpeg", "image/gif", "image/png"] },
                              size: { less_than: 3.megabyte }

  validates_presence_of :text, :priv
end

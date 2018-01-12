class TagsConnection < ActiveRecord::Base
  belongs_to :tag, class_name: 'Tag', foreign_key: 'id_tag'
  belongs_to :article, class_name: 'Article', foreign_key: 'id_article'
end

class Attachment < ActiveRecord::Base
  belongs_to :project

  has_attached_file :attachment, styles: { thumb: 'x150', medium: 'x300' },
                                 default_url: '/attchamnet/:style/missing.png'

  validates_attachment :attachment, content_type: { content_type: /\Aimage\/.*\Z/ },
                                    size: { less_than: 3.megabyte }
end

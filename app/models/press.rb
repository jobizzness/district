class Press < ActiveRecord::Base
  self.table_name = :press

  has_attached_file :pic, styles: {
                                small: '35x79#'
                              },
                              default_url: '/press/:style/missing.png'
  validates_attachment :pic, :presence => true, :content_type => { :content_type => ["image/tiff" ,"image/jpeg", "image/gif", "image/png", "application/pdf"] }
end

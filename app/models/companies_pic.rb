class CompaniesPic < ActiveRecord::Base
  belongs_to :company, foreign_key: :id_company

  has_attached_file :pic, styles: {
                                medium: '120x120#',
                                small: '60x60#'
                              },
                              default_url: '/companies_pics/:style/missing.png'
  validates_attachment :pic, :presence => true, :content_type => { :content_type => /\Aimage\/.*\Z/ }
end
